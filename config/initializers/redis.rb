#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:09:28
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-15 19:43:19
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

if Rails.env == 'test'
  $redis = MockRedis.new
else
  $redis = Redis.new
end

if ENV['WORKER']

  p "-=> SUBSCRIBED TO #{ENV['WORKER']}"

  $redis.subscribe(ENV['WORKER']) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      p "-=> ##{channel}: (#{data.length})"
      p data.inspect
    end
  end

end
