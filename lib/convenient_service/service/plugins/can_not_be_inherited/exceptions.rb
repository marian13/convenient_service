# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanNotBeInherited
        module Exceptions
          class ServiceIsInherited < ::ConvenientService::Exception
            def initialize_with_kwargs(service_class:, sub_service_class:)
              message = <<~TEXT
                Service `#{Utils::Class.display_name(sub_service_class)}` is inherited from `#{Utils::Class.display_name(service_class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{Utils::Class.display_name(sub_service_class)}` service.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
