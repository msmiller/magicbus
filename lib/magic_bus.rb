#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:06:37
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-24 11:52:53
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

module MagicBus
  include Redis::Objects

  # Fire-and-forget publish
  def self.publish(channels, data)
    channels.gsub(/\s+/, "").split(',').each do |c|
      $pubredis.publish c, data.to_json
    end
  end

  # Publish a message and wait on a reply
  def self.publish_rpc(channel, data)
    rpc_token = SecureRandom.urlsafe_base64(nil, false)
    $pubredis.publish channel, data.merge( {rpc_token: rpc_token} ).to_json

    rpc_redis = Redis.new
    rpc_redis.subscribe(rpc_token) do |on|
      on.message do |channel, msg|
        data = JSON.parse(msg)
        rpc_redis.unsubscribe(rpc_token)
        rpc_redis.close
        return(data)
      end
    end
    rpc_redis.close
    return nil
  end

  # Synchronous subscribe
  def self.subscribe(channels, callback=nil)
    $subredis.subscribe(channels) do |on|
      on.message do |channel, msg|
        data = JSON.parse(msg)
        if callback.nil?
          dump_message(channel, msg)
        else
          eval("#{callback}(channel, msg)")
        end
      end
    end
  end

  # Asynchronous subscribe
  def self.subscribe_async(channels, callback=nil)
    Thread.new do
      $subredis.subscribe(channels) do |on|
        on.message do |channel, msg|
          data = JSON.parse(msg)
          if callback.nil?
            dump_message(channel, msg)
          else
            eval("#{callback}(channel, msg)")
          end
        end
      end
    end
  end

  # Synchronous psubscribe
  def self.psubscribe(pattern, callback=nil)
    $subredis.psubscribe(pattern) do |on|
      on.pmessage do |pattern, channel, msg|
        data = JSON.parse(msg)
        if callback.nil?
          dump_message(channel, msg)
        else
          eval("#{callback}(channel, msg)")
        end
      end
    end
  end

  # Asynchronous psubscribe
  def self.psubscribe_async(pattern, callback=nil)
    Thread.new do
      tredis = Redis.new
      tredis.psubscribe(pattern) do |on|
        on.pmessage do |pattern, channel, msg|
          data = JSON.parse(msg)
          if callback.nil?
            dump_message(channel, msg)
          else
            eval("#{callback}(channel, msg)")
          end
        end
      end
    end
  end

  # Just dump to console if there's no callback
  def self.dump_message(channel, msg)
    data = JSON.parse(msg)
    p "-=> ##{channel}: (#{data.length})"
    p "-=> #{data.inspect}"
  end

end

=begin

require 'magic_bus'

MagicBus.publish('band,lyrics,albums', { 'message' => 'hi there' } )
MagicBus.publish('magicbus', { 'message' => 'this should go to everyone' } )

=end