# MAGICBUS

This is a prototype of a Redis-based message bus. The idea is to have something quick, light, and easy to maintain that still provides all the functionality of a REST API for low-volume microservice-to-microservice messaging.

## Core Methods

`publish(channels, data)`

Fire-and-forget publish.

`publish_rpc(channel, data)`

RPC style publish. The publisher will wait for a response.

`subscribe(channels, callback=nil)`

Subscribe to a list of channels synchronously. This for when a client needs to wait on a message.

`subscribe_async(channels, callback=nil)`

Asynchronous subscribe. This is the typical use case where a client wants to wait on message requests.

`psubscribe(pattern, callback=nil)`

Synchronous subscribe to a pattern. Mainly provided for completeness with the Redis command set.

## Channel Namespaces

The MagicBus uses a Twitter-esque namespace pattern:

`@channel` - this is for sending a message to a specific microservice. For instance, `@email` would be what an email service subscribes to and what a client would send to in order to send an email.

`#channel` - this is for "interests". For instance, an email service would want to know about Agents and Offices to be able to find mail templates, so it would subscribe to `[#agents, #offices]` to be notified of any updates.

`rpcXXXXXXXXXXXXXXXX` - these are ad-hoc channels used for waiting for and sending RPC-like responses to requests. The channel name is created by MagicBus and destroyed once the round-trip is complete.

