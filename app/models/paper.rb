class Paper < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :vision, resize_to_limit: [2048, 2048], format: :webp
    attachable.variant :thumb, resize_to_limit: [640, 640], format: :webp
  end

  concerning :Promptable do
    included do
      delegate :prompt, to: 'class'
    end

    class_methods do
      def prompt
        @@prompt ||= begin
          base = self.name.underscore.split('/').last
          File.read(Rails.root.join('config/prompts', "#{base}.text")).strip
        end
      end
    end
  end

  concerning :Statable do
    included do
      include AASM
      aasm column: :state do
        state :initial, default: true
        state :processing
        state :completed
        state :error
      end
    end
  end

  concerning :Analyzable do
    included do
      store_accessor :analysis_attrs,
                     :raw_result, :analyzed_text, :analyzed_values,
                     :error_reason, :num_try
      after_create_commit if: -> { image.attached? } do
        later(:run_analyze_image)
      end

      before_update if: -> { completed? && will_save_change_to_analysis_attrs? } do
        store_analyze_result
      end
    end

    def run_analyze_image
      ImageAnalyzer.new(self).run
    end

    def store_analyze_result
      if analyzed_values.present?
        analyzed_values.each do |key, value|
          am = "#{key}="
          if self.respond_to?(am)
            self.send(am, value)
          end
        end
      end
    end
  end
end
