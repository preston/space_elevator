# space_elevator - The ActionCable Client for Ruby

space_elevator is a _client_ for integrating a ruby application with a remote ActionCable-based backend provided by a Rails 7 (or recent) application or compatible framework. It allows for subscription and publication to multiple _channels_ simultaneously, features automatic message routing to subscription-specific handlers, and supports eavesdropping on wire-level messages, allowing you to harness the power of WebSockets and receive push notifications in your own Ruby applications!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'space_elevator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install space_elevator

### Troubleshooting Event Machine Installation
`gem` may not find the OpenSSL include directory necessary to compile. For macOS users with `brew install openssl` already run can install eventmachine like so:

`gem install eventmachine -- --with-cppflags=-I/opt/homebrew/opt/openssl/include`


## Usage

```ruby
require 'space_elevator'
require 'eventmachine'
require 'em-websocket-client'

EventMachine.run do

    url = 'ws://example.com'

    # Create a SpaceElevator::Client with a disconnect handler.
    client = SpaceElevator::Client.new(url) do
        puts 'Disconnected. Exiting...'
        EventMachine.stop_event_loop
    end

    # Connect the client using the provided callback block.
    client.connect do |msg|
        case msg['type'] # The server will always set a 'type'.
        when 'welcome' # Sent after a successful connection.
            puts 'The server says "welcome".'

            # Subscribe to something..
            client.subscribe(channel: 'ChatChannel') do |chat|
                puts "Received Chat Event: #{chat}"
                if chat['type'] == 'confirm_subscription'
                    puts "Subscription to #{chat['identifier']['channel']} confirmed!"
                    # Broadcast to the channel! The actual channel identifier and message payload is specific to your backend's WebSocket API.
                    client.publish({channel: 'ChatChannel'}, {subject: 'Hi', text: "What's up, y'all!?!?"})
                end
            end

            # Subscribe to something else simultaneously. Note the additional parameters!
            client.subscribe(channel: 'PlatformChannel', platform_id: platform_id) do |m|
                puts "Received Platform #{platform_id} Event: #{m}"
                # Do whatever, here.
            end
        when 'ping'
            puts 'The server just pinged us.'
        else
            puts msg
        end
    end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/preston/space_elevator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

This work is published under the Apache 2.0 license. Copyright (c) 2017-2023 Preston Lee.
