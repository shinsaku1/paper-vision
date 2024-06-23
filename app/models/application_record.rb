class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  concerning :JobExecutionFeature do
    class_methods do
      def later(method, *args)
        RunClassMethodJob.perform_later(self.name, method.to_s, *args)
      end
    end
    def later(method, *args)
      RunInstanceMethodJob.perform_later(self, method.to_s, *args)
    end
  end

  delegate :url_helpers, to: 'Rails.application.routes'
end
