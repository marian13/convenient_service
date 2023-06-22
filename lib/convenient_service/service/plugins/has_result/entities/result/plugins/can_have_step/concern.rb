# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step, nil]
                    #
                    def step
                      Utils.memoize_including_falsy_values(self, :@step) { extra_kwargs[:step] }
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
