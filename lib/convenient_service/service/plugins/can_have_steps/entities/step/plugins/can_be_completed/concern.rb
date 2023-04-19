# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeCompleted
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def completed?
                      Utils::Bool.to_bool(internals.cache[:completed])
                    end

                    ##
                    # @return [Bool]
                    #
                    def not_completed?
                      !completed?
                    end

                    ##
                    # @return [void]
                    #
                    def mark_as_completed!
                      internals.cache[:completed] = true
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
