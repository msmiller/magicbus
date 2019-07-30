#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:09:28
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-29 17:42:30
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

require 'magic_bus'

p "==== REDIS INIT ==== #{ENV['WORKER']}"

if Rails.env == 'test'
  $redis = MockRedis.new
  $pubredis = MockRedis.new
  $subredis = MockRedis.new
else
  $redis = Redis.new
  $pubredis = Redis.new
  $subredis = Redis.new
end

unless ENV['WORKER'].nil?

  base_subscribe = [  "#magicbus",
                      "@#{ENV['WORKER']}",
                      "##{ENV['WORKER']}"
                   ]

  MagicBus.subscribe_async( base_subscribe, 'Blivot.dump' )
  p "-=> SUBSCRIBED (ASYNC) TO #{base_subscribe.join(', ')}"

end
