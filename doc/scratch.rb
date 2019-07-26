reload!
MagicBus.publish('band', { 'message' => 'hi there' } )
MagicBus.publish('band_1234_', { 'message' => 'hi there 1234' } )

####

@lock = Redis::Lock.new('serialize_stuff') # , :expiration => 15, :timeout => 0.1)
@lock.lock do
  sleep 1000000
end

####

class FooNotifier
  def foo(message)
    p message
  end
end

####

require 'magic_bus'

reload!
reload_lib!

thing = { id: 1234, class: 'Frodus', name: 'Ack Oop', priority: 42 }.to_dot

MagicBus.deposit(thing, Time.now + 5.minutes, '@albums')

