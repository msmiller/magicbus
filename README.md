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

```ruby
subscribe([#agents, #offices]. "my_callback")
```

But it also wants to get email sending requests, so it needs to listen to it's own channels. Plus a channel related to email in general. This changes the above line to:

```ruby
subscribe([@email, #email, #agents, #offices]. "my_callback")
```

And we want all microservices to listen to a global channel for system-level commands. So, let's change the EMailer's subscriptions once more:

```ruby
subscribe([@email, #email, #agents, #offices, #magicbus]. "my_callback")
```

To send an email, another microservice would call:

```ruby
publish('@email', { agent_name: 'John Smith', recipient: 'Fred Jones', ...})
```

This is a "fire-and-forget" publishing - the sender assumes the recipient will handle it and doesn't need a response. But what if you want to get back a MessageReceipt ID so you could also interogate if the email was send and delivered? Then you'd use the RPC mode as follows:

```ruby
response = publish_rpc('@email', { command: 'send', template_code: 'renter_confirm', agent_name: 'John Smith', recipient: 'Fred Jones', ...})
message_receipt_id = response.data['message_receipt_id']
```

It needs to be done this way because email gets sent in the background, so the actual results may not be available in a reasonable amount of time for the RPC call.

Now let's say that the sending service wants to see if the email was delivered, you make another RPC style call here:

```ruby
response = publish_rpc('@email', { command: 'get_receipt', receipt_id: 12345678)
message_receipt = response.data['message_receipt']
```

Or ... the Emailer could be written to broadcast it's MessageReceipts after sending was complete to anyone interested. In this case, the Emailer would pubish the MessageReceipts on the channel of the sender (it'd store the source in the MessageReceipt).

```ruby
# Sender
subscribe([@my_channel, #magicbus, ...]. "my_callback")

# Emailer ... performed after an email was sent via the SMTP gateway:
publish('@my_channel', { message_receipt: { id: 12345678, delivered_on: '2019-07-04', ... } })
```

In this scenario, the sending service is always listening for updates from the Emailer with MessageReceipts. If the sending service wants MessageReceipts to always be available, this is a better strategy. But if it only needs them on-demand, then the RPC method works fine.

This bus approach provides great flexibility and also frees up the microservices from needing to know a large number of endpoints, or fopr needing complex internal routing for everything to be able to talk to each other. All that's needed is agreement on channels and payloads.

## Advantages of Redis Pub/Sub

- Synchronous and asynchronous operation (via use of Ruby Threads).
- Fan-out is built in - it automatically sends the message to all subscribers.
- Non-persisted - messages are routed to channels and removed when consumed. So publishing something that isn't consumed doesn't eat up any resources. This is nice for writing features that other services may not be using yet.
- Easy to code and maintain - the current `magic_bus.rb` I'm working on for this protytype is under 120 lines.

