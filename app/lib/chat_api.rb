# frozen_string_literal: true

class ChatAPI
  def initialize(provider = :anthropic, provider_params = {})
    @provider = verify_provider(provider)
    @provider_params = provider_params
  end

  def api
    @api = case @provider
    when :anthropic
      ChatAPI::Anthropic.new(@provider_params)
    when :openai, :chatgpt, :gpt, :open_ai
      ChatAPI::OpenAI.new(@provider_params)
    else raise "Invalid provider=#{@provider}"
    end
  end

  def call(prompt:, image: nil)
    api.call(prompt: prompt, image: image)
  end

  private
  def verify_provider(provider)
    provider = provider.to_sym
    raise "Unknown provider=#{provider}" unless provider.in?([:anthropic, :openai])
    provider
  end
end
