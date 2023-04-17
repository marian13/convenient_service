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
                      Utils::Bool.to_bool(@completed)
                    end

                    ##
                    # @return [void]
                    #
                    def mark_as_completed!
                      @completed = true
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
