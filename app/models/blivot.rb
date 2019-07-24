#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-23 17:23:16
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-23 17:54:51
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

# This is just a basic class to ring out callbacks for pub/sub
class Blivot

  def self.dump(channel, message)
    data = JSON.parse(message)
    puts "-=> Received: ##{channel}(#{data.length})"
    ap data
  end

end