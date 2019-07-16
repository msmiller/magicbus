#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-15 16:36:17
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-15 19:31:06
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

if ENV['WORKER']

  $workerid = ENV['WORKER']
  p "-=> WORKER: #{$workerid}" 

end