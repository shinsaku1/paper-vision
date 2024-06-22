# frozen_string_literal: true

class ChatAPI::Image
  def initialize(data: nil, url: nil, media_type:)
    @data = data
    @media_type = media_type
    @url = url
  end
  attr_reader :data, :url, :media_type
end
