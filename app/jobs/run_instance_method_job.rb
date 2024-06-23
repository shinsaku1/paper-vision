class RunInstanceMethodJob < ApplicationJob
  def perform(model, *args)
    model.send(*args)
  end
end
