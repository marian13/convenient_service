# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class MergeSections
            include RailsService::Config

            attribute :header, :string
            attribute :body, :string

            validates :header, presence: true
            validates :body, presence: true

            def result
              success(merged_sections: "#{header}\n#{body}")
            end
          end
        end
      end
    end
  end
end
