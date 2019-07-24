#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:12:16
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-24 13:16:10
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

if Rails.env == 'test'
Redis::Objects.redis = Redis::Namespace.new("magicbus", :redis => MockRedis.new)
else
Redis::Objects.redis = Redis::Namespace.new("magicbus", :redis => Redis.new)
end

$buslog = Redis::List.new("#{ENV['WORKER'] || 'web'}_log", :maxlength => 100)
def buslog(message)
  $buslog << "#{Time.now.to_s(:db)} #{message}"
end
buslog("Logging into #{ENV['WORKER'] || 'web'}_log")
