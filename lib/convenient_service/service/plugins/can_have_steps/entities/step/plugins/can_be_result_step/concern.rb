# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeResultStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def result_step?
                      method_step? && method.value.to_sym == :result
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
