# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module ForbidsConvenientServiceEntitiesAsConstructorArguments
        module Exceptions
          class ServicePassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, other_service:)
              message = <<~TEXT
                Other service `#{Utils::Class.display_name(other_service.class)}` is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(message)
            end
          end

          class ResultPassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, result:)
              message = <<~TEXT
                Result of `#{Utils::Class.display_name(result.service.class)}` is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(message)
            end
          end

          class StepPassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, step:)
              message = <<~TEXT
                Step of `#{step.printable_container}` is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
