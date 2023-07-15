# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        module UsingDryValidation
          module Concern
            include Support::Concern

            class_methods do
              def contract(&block)
                (@contract ||= ::Class.new(::Dry::Validation::Contract))
                  .tap { |contract| contract.class_exec(&block) if block }
              end
            end
          end
        end
      end
    end
  end
end
