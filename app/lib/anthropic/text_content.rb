# frozen_string_literal: true

class Anthropic::TextContent < Anthropic::Content
  def initialize(text)
    @text = text
  end
  attr_reader :text

  def to_content
    { type: 'text', text: text}
  end
end
