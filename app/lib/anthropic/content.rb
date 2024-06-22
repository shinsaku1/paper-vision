# frozen_string_literal: true

class Anthropic::Content
  def initialize(params:)
    @params = params
  end
  attr_reader :params
end
