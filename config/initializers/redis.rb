#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:09:28
# @Last Modified by:   msmiller
# @Last Modified time: 2019-10-22 16:10:54
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

  if Konfig.use_redbus
      p "-=> ABOUT TO REGISTER WITH REDBUS"
      Redbus.endpoint = ENV['WORKER']
      Redbus::Registration.register_endpoint
      Redbus::Registration.register_interest("##{ENV['WORKER']}")
      Redbus::Registration.register_interest("#magicbus")
      subs = Redbus::Registration.registered_interests + Redbus::Registration.registered_endpoints
      p "----"
      ap subs
      p "----"
      Redbus::Lpubsub.subscribe_async( Redbus::Registration.subscribe_list, "Blivot::rbdump" )
      # Redbus::Lpubsub.subscribe_all( "Blivot::rbdump" )
      p "-=> SUBSCRIBED (ASYNC) TO #{subs.join(', ')}"
  else
    base_subscribe = [  "#magicbus",
                        "@#{ENV['WORKER']}",
                        "##{ENV['WORKER']}"
                     ]

    MagicBus.subscribe_async( base_subscribe, 'Blivot.dump' )
    p "-=> SUBSCRIBED (ASYNC) TO #{base_subscribe.join(', ')}"
  end



end
