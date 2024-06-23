# frozen_string_literal: true

class Anthropic::Client
  concerning :Configuration do
    included do
      delegate :configuration, to: self
    end
    class_methods do
      def configuration
        @@configuration ||= {
          api_key: ENV['ANTHROPIC_API_KEY'],
          model: 'claude-3-5-sonnet-20240620',
          version: '2023-06-01'
        }
      end
    end
  end

  def message(*messages, max_tokens: 1024)
    messages = [messages].flatten
    messages = messages_to_hash(messages)
    conn = Faraday.new(
      url: 'https://api.anthropic.com',
      headers: {
        'Content-Type' => 'application/json',
        'x-api-key' => configuration[:api_key],
        'anthropic-version' => configuration[:version],
      }
    )
    conn.post('/v1/messages') do |req|
      params = {
        model: configuration[:model],
        max_tokens: max_tokens,
        messages: messages
      }
      req.body = params.to_json
    end
  end

  def messages_to_hash(messages)
    messages.map do |message|
      case message
      when Anthropic::Message then message.to_message
      when Hash then message
      else raise "Unknown message type: #{message.class}"
      end
    end
  end
end
