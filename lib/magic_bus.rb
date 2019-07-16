#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:06:37
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-15 19:52:30
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

module MagicBus
  include Redis::Objects

  def self.publish(channels, data)
    channels.gsub(/\s+/, "").split(',').each do |c|
      $redis.publish c, data.to_json
    end
  end

  def self.subscribe(channel, callback)
  end

end

=begin

require 'magic_bus'

MagicBus.publish('band,lyrics,albums', { 'message' => 'hi there' } )

=end