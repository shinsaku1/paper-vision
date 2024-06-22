# frozen_string_literal: true

class ChatAPI::Anthropic
  def initialize(params)
    @params = params
  end
  def call(prompt:, image:)
    client = ::Anthropic::Client.new
    user_message = build_user_message(image, prompt)
    Result.new(client.message(user_message))
  end

  def build_user_message(image, prompt)
    message = ::Anthropic::Message.new(role: 'user')
    message.contents << ::Anthropic::ImageContent.new(image.data, media_type: image.mime_type)
    message.contents << ::Anthropic::TextContent.new(prompt)
    message
  end

  class Result
    def initialize(response)
      @response = JSON.parse(response.body)
    end

    def success?
      content && !content.match(/<error>/)
    end

    def error?
      !success?
    end

    def content_error?
      true
    end

    def system_error?
      false
    end

    def content
      @response.dig 'content', 0, 'text'
    end
  end
end
