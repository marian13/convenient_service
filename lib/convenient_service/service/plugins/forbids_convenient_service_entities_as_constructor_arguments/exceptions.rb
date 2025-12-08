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

          class StatusPassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, status:)
              message = <<~TEXT
                Status of `#{Utils::Class.display_name(status.result.service.class)}` result is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, convert it to symbol or try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(message)
            end
          end

          class DataPassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, data:)
              message = <<~TEXT
                Data of `#{Utils::Class.display_name(data.result.service.class)}` result is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, convert it to hash or try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(message)
            end
          end

          class MessagePassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, message:)
              exception_message = <<~TEXT
                Message of `#{Utils::Class.display_name(message.result.service.class)}` result is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, convert it to string or try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(exception_message)
            end
          end

          class CodePassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, code:)
              message = <<~TEXT
                Code of `#{Utils::Class.display_name(code.result.service.class)}` result is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, convert it to symbol or try to reorganize `#{Utils::Class.display_name(service.class)}` service.
              TEXT

              initialize(message)
            end
          end

          class EntityPassedAsConstructorArgument < ::ConvenientService::Exception
            def initialize_with_kwargs(selector:, service:, entity:)
              message = <<~TEXT
                Convenient Service entity `#{Utils::Class.display_name(entity.class)}` is passed as constructor argument `#{selector}` to `#{Utils::Class.display_name(service.class)}`.

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
