# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Castable
      module Exceptions
        class CastIsNotOverridden < ::ConvenientService::Exception
          def initialize_with_kwargs(klass:)
            message = <<~TEXT
              Cast method (.cast) of `#{klass}` is NOT overridden.
            TEXT

            initialize(message)
          end
        end

        class FailedToCast < ::ConvenientService::Exception
          def initialize_with_kwargs(other:, klass:)
            message = <<~TEXT
              Failed to cast `#{other.inspect}` into `#{klass}`.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
