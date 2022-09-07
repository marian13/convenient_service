# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAttributes
        module UsingActiveModelAttributes
          module Concern
            include Support::Concern

            included do |service_class|
              service_class.include Patches::ActiveModelAttributes
            end
          end
        end
      end
    end
  end
end
