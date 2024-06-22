# frozen_string_literal: true

require 'base64'

class ChatAPI::OpenAI
  def initialize(params)
    @params = params
  end

  def call(prompt:, image:)
    client = ::OpenAI::Client.new
    user_messages = build_user_messages(image, prompt)
    begin
      resp = client.chat(
        parameters: {
          model: 'gpt-4o',
        messages: [ { role: 'user', content: user_messages } ]
        })
      Rails.logger.info("ChatAPI::OpenAI: call.success #{resp}")
      Result.new(resp)
    rescue => e
      Rails.logger.info("ChatAPI::OpenAI: call.error #{e.message}")
      ErrorResult.new(e)
    end
  end

  def build_user_messages(image, prompt)
    image_url = if image.url =~ /^https:/
      image.url
    else
      base64_image_url(image)
    end
    [
      { type: 'image_url', image_url: { url: image_url } },
      { type: 'text', text: prompt}
    ]
  end

  def base64_image_url(image)
    b64 = Base64.strict_encode64(image.data)
    media_type = image.media_type
    "data:#{media_type};base64,#{b64}"
  end

  class Result
    def initialize(response)
      @response = response
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
      @response.dig 'choices', 0, 'message','content'
    end
  end

  class ErrorResult
    def initialize(exception)
      @exception = exception
    end

    def success?
      false
    end

    def error?
      true
    end

    def content_error?
      false
    end

    def system_error?
      true
    end

    def content
      @exception.message
    end
  end
end
