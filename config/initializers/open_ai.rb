if ENV['OPENAI_API_KEY'].present?
  OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPENAI_API_KEY")
    config.log_errors = Rails.env.development? # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production.
  end
end
