#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 19:12:16
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-15 19:13:06
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

if Rails.env == 'test'
Redis::Objects.redis = Redis::Namespace.new("magicbus", :redis => MockRedis.new)
else
Redis::Objects.redis = Redis::Namespace.new("magicbus", :redis => Redis.new)
end
