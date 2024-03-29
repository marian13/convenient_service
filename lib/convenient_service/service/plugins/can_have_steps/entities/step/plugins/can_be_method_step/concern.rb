# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Symbol, nil]
                    #
                    def method
                      extra_kwargs[:method]
                    end

                    ##
                    # @return [Boolean]
                    #
                    def method_step?
                      Utils.to_bool(method)
                    end

                    ##
                    # @return [Boolean]
                    #
                    def result_step?
                      method_step? && method == :result
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
