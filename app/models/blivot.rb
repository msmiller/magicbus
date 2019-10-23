#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-23 17:23:16
# @Last Modified by:   msmiller
# @Last Modified time: 2019-10-23 11:20:17
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

# This is just a basic class to ring out callbacks for pub/sub

require 'magic_bus'

LYRICS = [
  "Every day I get in the queue (too much, Magic Bus)",
  "To get on the bus that takes me to you (too much, Magic Bus)",
  "I'm so nervous, I just sit and smile (too much, Magic Bus)",
  "You house is only another mile (too much, Magic Bus)",
  "Thank you, driver, for getting me here (too much, Magic Bus)",
  "You'll be an inspector, have no fear (too much, Magic Bus)",
  "I don't want to cause no fuss (too much, Magic Bus)",
  "But can I buy your Magic Bus? (too much, Magic Bus)",
  "I don't care how much I pay (too much, Magic Bus)",
  "I want to drive my bus to my baby each day (too much, Magic Bus)",
  "I want it, I want it, I want it, I want it (you can't have it)",
  "Thruppence and sixpence every day",
  "Just to drive to my baby",
  "Thruppence and sixpence each day",
  "'Cause I drive my baby every way",
  "Magic bus, Magic Bus, Magic Bus",
  "Magic bus, Magic Bus, Magic Bus",
  "Magic bus, Magic Bus, Magic Bus",
  "Magic bus, Magic Bus, Magic Bus",
  "I said, now I've got my Magic Bus (too much, Magic Bus)",
  "I said, now I've got my Magic Bus (too much, Magic Bus)",
  "I drive my baby every way (too much, Magic Bus)",
  "Each time I go a different way (too much, Magic Bus)",
  "I want it, I want it, I want it, I want it",
  "I want it, I want it, I want it, I want it",
  "Every day you'll see the dust (too much, Magic Bus)",
  "As I drive my baby in my Magic Bus (too much, Magic Bus)"
]

BANDMEMBERS = [
  "Roger Daltrey",
  "Pete Townshend",
  "John Entwistle",
  "Keith Moon"
]

ALBUMS = [
  "My Generation (1965)",
  "A Quick One (1966)",
  "The Who Sell Out (1967)",
  "Tommy (1969)",
  "Live At Leeds (1970)",
  "Meaty Beaty Big & Bouncy (1971)",
  "Who's Next (1971)",
  "Quadrophenia (1973)",
  "Odds & Sods (1974)",
  "The Who By Numbers (1975)",
  "Who Are You (1978)",
  "The Kids Are Alright (1979)"
]

class Blivot

  def self.dump(channel, message)
    data = JSON.parse(message)
    puts "-=> Received: #{channel}(#{data.length})"
    ap data
    buslogger("#{channel} : #{data.to_s}")
    #######
    if data['rpc_token']
      if data['message'] == 'get_three_lines'
        MagicBus.publish( data['rpc_token'], { 'message' => LYRICS[0..2].join(' / ') } )
      elsif data['message'] == 'deposit'
        # create a faux 'Album.2' object
        thing = { id: 2, class: 'Album', name: ALBUMS[1] }.to_dot
        ap data
        MagicBus.deposit(thing, data['expire_at'], data['rpc_token'])
      else
        MagicBus.publish( data['rpc_token'], { 'message' => 'rpc works!' } )
      end
    end

    if data['message'] == 'clearlogs'
      $buslog.clear
    end

  end

  def self.rbdump(*args)
    channel, message = args
    data = message # JSON.parse(message) 

ap data
p "-=> Received: #{channel}(#{data.length})"
ap data
    buslogger("#{channel} : #{data.to_s}")
    #######
    if data['rpc_token']
      if data['message'] == 'get_three_lines'
        MagicBus.publish( data['rpc_token'], { 'message' => LYRICS[0..2].join(' / ') } )
      elsif data['message'] == 'deposit'
        # create a faux 'Album.2' object
        thing = { id: 2, class: 'Album', name: ALBUMS[1] }.to_dot
        ap data
        MagicBus.deposit(thing, data['expire_at'], data['rpc_token'])
      else
        MagicBus.publish( data['rpc_token'], { 'message' => 'rpc works!' } )
      end
    end

    if data['message'] == 'clearlogs'
      $buslog.clear
    end

  end

end