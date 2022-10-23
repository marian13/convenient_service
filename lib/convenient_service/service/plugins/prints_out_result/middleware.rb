# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module PrintsOutResult
        class Middleware < Core::MethodChainMiddleware
          def next(...)
            original_result = chain.next(...)

            print_out_result(original_result) if print_out?(entity)

            original_result
          end

          private

          def print_out?(entity)
            entity.instance_variable_get(:@print_out) == true
          end

          def print_out_result(result)
            if result.success?
              puts ::Paint["#{result.data.value}", :green, :bold]
            else
              puts ::Paint["#{result.message}", :red, :bold]
            end
          end
        end
      end
    end
  end
end
