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
              module HasResult
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Exceptions::StepHasUnknownType]
                    #
                    def result
                      ::ConvenientService.raise Exceptions::StepHasUnknownType.new(step: self)
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
