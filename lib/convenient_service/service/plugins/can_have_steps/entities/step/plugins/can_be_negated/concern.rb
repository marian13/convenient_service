# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeNegated
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def negated_step?
                      Utils.to_bool(params.extra_kwargs[:negated])
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
