# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanHaveStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def from_step?
                      Utils.to_bool(step)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step, nil]
                    #
                    def step
                      Utils.memoize_including_falsy_values(self, :@step) { extra_kwargs[:step] }
                    end

                    ##
                    # @return [ConvenientService::Service]
                    #
                    def original_service
                      Utils.memoize_including_falsy_values(self, :@original_service) { from_step? ? extra_kwargs[:original_service] : service }
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
