#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-23 17:23:16
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-24 11:54:45
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

# This is just a basic class to ring out callbacks for pub/sub

require 'magic_bus'

class Blivot

  def self.dump(channel, message)
    data = JSON.parse(message)
    puts "-=> Received: #{channel}(#{data.length})"
    ap data
    #######
    if data['rpc_token']
      puts "-=> Publish RPC response to: #{data['rpc_token']})"
      MagicBus.publish( data['rpc_token'], { 'message' => 'rpc works!' } )
    end
  end

end