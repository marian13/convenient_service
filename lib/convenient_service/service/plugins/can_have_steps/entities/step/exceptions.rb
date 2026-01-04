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
            module Exceptions
              class StepHasNoOrganizer < ::ConvenientService::Exception
                def initialize_with_kwargs(step:)
                  message = <<~TEXT
                    Step `#{step.printable_action}` has not assigned organizer.

                    Did you forget to set it?
                  TEXT

                  initialize(message)
                end
              end

              class StepResultDataNotExistingAttribute < ::ConvenientService::Exception
                ##
                # @param key [Symbol]
                # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                # @return [void]
                #
                def initialize_with_kwargs(key:, step:)
                  message = <<~TEXT
                    Step `#{step.printable_action}` result does NOT return `:#{key}` data attribute.

                    Maybe there is a typo in `out` definition?

                    Or `success` of `#{step.printable_action}` accepts a wrong key?
                  TEXT

                  initialize(message)
                end
              end

              class UnsupportedKeyType < ::ConvenientService::Exception
                ##
                # @param key [Symbol]
                # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                # @return [void]
                #
                def initialize_with_kwargs(key:, step:)
                  message = <<~TEXT
                    Input key `#{key.inspect}` of step `#{step.printable_action}` has unsupported type `#{key.class}`.

                    Maybe there is a typo in `in` definition?
                  TEXT

                  initialize(message)
                end
              end
            end
          end
        end
      end
    end
  end
end
