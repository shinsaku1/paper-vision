# frozen_string_literal: true
require 'base64'

class Anthropic::ImageContent < Anthropic::Content
  def initialize(image, media_type:)
    @image = image
    @media_type = media_type
  end
  attr_reader :image, :media_type

  def to_content
    { type: 'image',
      source: {
        type: 'base64',
        media_type: media_type,
        data: Base64.strict_encode64(image)
      }
    }
  end
end
