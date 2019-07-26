#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:06:37
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-26 12:51:59
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
    rpc_token = "rpc." + SecureRandom.urlsafe_base64(nil, false)
    $pubredis.publish channel, data.merge( {rpc_token: rpc_token} ).to_json

    # See: https://github.com/redis/redis-rb#timeouts
    rpc_redis = Redis.new
    rpc_redis.subscribe_with_timeout(5, rpc_token) do |on|
      on.message do |channel, msg|
        data = JSON.parse(msg)
        rpc_redis.unsubscribe(rpc_token)
        rpc_redis.close
        return(data)
      end
    end

    rpc_redis.unsubscribe(rpc_token)
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

  # WRITE-THRU CACHE MODE


  def self._base_redis_key(item)
    "#{item[:class] || item.class}.#{item.id}"
  end

  def self._redis_key(item)
    "magicache.#{_base_redis_key(item)}"
  end


  # Store an object out in Redis for temporary persistence and respond back if there's an rpc_token
  def self.deposit(item, expire_at, rpc_token)
    base_redis_key = _base_redis_key(item)
    redis_key = _redis_key(item)
    @hash = Redis::HashKey.new(redis_key)
    item.each do |k,v|
      @hash[k] = v
    end
    if expire_at
      $redis.expireat "magicbus:#{redis_key}", expire_at
    end
    # Publish back an acknowledge that it's ready so the requester can get the data
    if rpc_token
      $pubredis.publish rpc_token, { redis_key: base_redis_key }.to_json
    end
  end

  # Pull an object that's being persisted, if it's not there, do an RPC publish to get it
  def self.retrieve(item_class, item_id, channel, expire_at=nil)
    base_redis_key = "#{item_class}.#{item_id}"
    redis_key = "magicache.#{base_redis_key}"

    @hash = Redis::HashKey.new(redis_key)
    # If the object doesn't exist, then request it over RPC
    if @hash.nil? || @hash.value.nil? || @hash.value.empty?
      data = { message: 'deposit', item_class: item_class, item_id: item_id, expire_at: expire_at }
      result = publish_rpc(channel, data)
      # Reload the hash from Redis
      @hash = Redis::HashKey.new(redis_key)
    end

    ap @hash.value
    return @hash.value.to_dot
  end

  # ###########################################
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