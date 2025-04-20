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
          class Method
            module Exceptions
              class MethodHasNoOrganizer < ::ConvenientService::Exception
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @return [void]
                #
                # @internal
                #   TODO: Introduce `Method#step` for more verbose message?
                #
                def initialize_with_kwargs(method:)
                  message = <<~TEXT
                    Organizer for method `:#{method.name}` is NOT assigned yet.

                    Did you forget to set it?
                  TEXT

                  initialize(message)
                end
              end

              class MethodIsNotOutputMethod < ::ConvenientService::Exception
                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [void]
                #
                def initialize_with_kwargs(method:, container:)
                  message = <<~TEXT
                    Method `#{method.name}` is NOT an `out` method.
                  TEXT

                  initialize(message)
                end
              end

              class OutMethodStepIsNotCompleted < ::ConvenientService::Exception
                ##
                # @param method_name [Symbol]
                # @return [void]
                #
                def initialize_with_kwargs(method_name:)
                  message = <<~TEXT
                    `out` method `#{method_name}` is called before its corresponding step is completed.

                    Maybe it makes sense to change steps order?
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
