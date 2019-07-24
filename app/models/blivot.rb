#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-23 17:23:16
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-23 17:25:13
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

class Blivot

  def self.a_callback(channel, message)
    data = JSON.parse(message)
    p "Blivot.a_callback -=> ##{channel}: (#{data.length})"
    p "Blivot.a_callback -=> #{data.inspect}"
  end

end