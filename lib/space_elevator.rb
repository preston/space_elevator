require 'space_elevator/version'

module SpaceElevator
    # Super-light utility for integrating with ActionCable-based backends.
    class Client
        attr_accessor :client
        attr_accessor :connected
        attr_accessor :connection_handler
        attr_accessor :channel_handlers
        attr_accessor :disconnect_handler
        attr_accessor :url

        def initialize(url, &disconnect_handler)
            self.url = url
            self.disconnect_handler = disconnect_handler
      end

        def connect(&block)
            self.connection_handler = block
            self.channel_handlers = {}
            self.client = EventMachine::WebSocketClient.connect(url)
            client.callback do
                puts "Connected WebSocket to #{url}."
                self.connected = true
            end
            client.stream do |raw|
                message = parse_message(raw.to_s)
                if message['identifier'] && message['identifier']['channel']
                    channel_handlers[message['identifier']['channel']].call(message)
                else
                    connection_handler.call(message)
                end
            end
            client.disconnect do
                self.connected = false
                disconnect_handler.call
            end
         end

        def subscribe_to(channel, data = nil, &block)
            push(create_subscribe_message(channel, data))
            channel_handlers[channel] = block
        end

        def push(msg)
            client.send_msg(msg)
        end

        def publish(channel, data)
            msg = create_publish_message(channel, data)
            # puts "PUSHING: #{msg}"
            push(msg)
          end

        def create_publish_message(channel, data)
            message = {
                command: 'message',
                identifier: { channel: channel }
            }
            if data
                message[:data] = data.to_json # .merge!(data)
          # message[:data] = message[:data].to_json
      end
            message[:identifier] = message[:identifier].to_json
            # puts message
            message.to_json
        end

        def create_subscribe_message(channel, data)
            message = {
                command: 'subscribe',
                identifier: { channel: channel }
            }
            message[:identifier].merge!(data) if data
            message[:identifier] = message[:identifier].to_json
            # puts message
            message.to_json
        end

        def parse_message(message)
            result = JSON.parse(message)
            result['identifier'] = JSON.parse(result['identifier']) if result['identifier']
            result['data'] = JSON.parse(result['data']) if result['data']
            result
        end
    end
end
