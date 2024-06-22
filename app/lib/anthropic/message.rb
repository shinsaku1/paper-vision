# frozen_string_literal: true
require 'base64'

class Anthropic::Message
  def initialize(role: 'user')
    @role = role
  end
  attr_reader :role

  def contents
    @contents ||= []
  end

  def to_message
    {
      role: role,
      content: contents.map(&:to_content)
    }
  end
end
