#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:06:37
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-15 22:20:31
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

module MagicBus
  include Redis::Objects

  def self.publish(channels, data)
    channels.gsub(/\s+/, "").split(',').each do |c|
      $redis.publish c, data.to_json
    end
  end

  def self.subscribe(channels, callback=nil)
Thread.new do
    $redis.subscribe(channels) do |on|
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