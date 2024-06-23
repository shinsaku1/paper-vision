class RunClassMethodJob < ApplicationJob
  def perform(klass, *args)
    Object.const_get(klass).send(*args)
  end
end
