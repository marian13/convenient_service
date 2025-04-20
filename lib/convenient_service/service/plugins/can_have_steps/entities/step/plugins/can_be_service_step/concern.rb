# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeServiceStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Class<ConvenientService::Service>]
                    #
                    def service_class
                      action if service_step?
                    end

                    ##
                    # @return [Boolean]
                    #
                    def service_step?
                      action.instance_of?(Class)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Exceptions::StepIsNotServiceStep]
                    #
                    # @internal
                    #   NOTE: `service_result` returns a foreign result that is later converted to own result by `HasResult` middleware.
                    #
                    def service_result
                      Commands::CalculateServiceResult.call(step: self)
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
