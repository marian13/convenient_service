# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module TriesToConvertResultDuckToResult
        class Middleware < MethodChainMiddleware
          intended_for :result, entity: any_entity

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          # @internal
          #   NOTE: When original result is a result duck and it has `NoMethodError` exception, that exception should be raised just like any other exception. See specs for details.
          #
          #   NOTE: `exception.receiver` is available on `NameError` descendants (like `NoMethodError`), but NOT on `StandardError`.
          #   - https://ruby-doc.org/core-2.7.1/NoMethodError.html
          #   - https://ruby-doc.org/core-2.7.1/NameError.html#method-i-receiver
          #   - https://ruby-doc.org/core-2.7.1/StandardError.html
          #
          def next(...)
            original_object = chain.next(...)

            result_duck, result = try_convert(original_object)

            result_duck ? result : original_object
          end

          private

          ##
          # @param original_object [Object] Can be any type.
          # @return [Array]
          # @raise [NoMethodError]
          #
          def try_convert(original_object)
            result = original_object.result

            [true, result]
          rescue ::NoMethodError => exception
            raise exception if original_object.respond_to?(:result)

            [false, nil]
          end
        end
      end
    end
  end
end
