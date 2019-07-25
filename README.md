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

## How RPC Mode Works

This was actually pretty easy. The sender calls the `publish_rpc` method. This is a blocking (synchronous mode) method. It sends the message along with an RPC channel token. Once it sends, it does a `subscribe` on the RPC channel token and waits for a response. The target microservice gets the request and sends the return back by doing a `publish` on the RPC channel. Once the original sender gets it's response, it unsubscribes from the RPC channel and closes the Redis connection it was using to listen on. Easy!

## Example Use Case

Let's take the case of an email-sending microservice. The Emailer has templates that are global, Agent-owned, and Office-owned. So it needs to know when Agents and Offices are added, changed, or removed in near-real-time so that if a user tries to manage their email templates, it's not waiting on the next ETL update to find the user. So to get updates to core models, it would:

 ```
 subscribe([#agents, #offices]. "my_callback")
 ```
