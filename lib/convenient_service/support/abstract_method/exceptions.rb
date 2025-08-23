# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module AbstractMethod
      module Exceptions
        class AbstractMethodNotOverridden < ::ConvenientService::Exception
          ##
          # @param instance [Object] Can be any type.
          # @param method [Symbol, String]
          # @return [void]
          #
          def initialize_with_kwargs(instance:, method:)
            klass = instance.is_a?(::Class) ? instance : instance.class
            method_type = Utils::Object.resolve_type(instance)

            message = <<~TEXT
              `#{klass}` should implement abstract #{method_type} method `#{method}`.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
