#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:09:28
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-15 22:20:42
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

require 'magic_bus'

if Rails.env == 'test'
  $redis = MockRedis.new
else
  $redis = Redis.new
end

p "==== REDIS INIT ===="

p ENV['WORKER']

unless ENV['WORKER'].nil?

  MagicBus.subscribe(["magicbus", ENV['WORKER']], 'MagicBus::dump_message')
  p "-=> SUBSCRIBED TO #{ENV['WORKER']}"
  # MagicBus.psubscribe("magicbus", 'MagicBus::dump_message')
  # p "-=> SUBSCRIBED TO magicbus"

$tredis = Redis.new
p $tredis.inspect
Thread.new do
$tredis.psubscribe("#{ENV['WORKER']}_*_") do |on|
  # on.message do |channel, msg|
  on.pmessage do |pattern, channel, msg|
    data = JSON.parse(msg)
    p "-=> ##{channel}: (#{data.length})"
    p data.inspect   
  end
end
end

  # $redis.subscribe(ENV['WORKER']) do |on|
  #   on.message do |channel, msg|
  #     data = JSON.parse(msg)
  #     p "-=> ##{channel}: (#{data.length})"
  #     p data.inspect   
  #   end
  # end

end
