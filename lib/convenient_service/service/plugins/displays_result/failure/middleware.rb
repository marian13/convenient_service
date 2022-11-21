# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module DisplaysResult
        module Failure
          class Middleware < Core::MethodChainMiddleware
            def next(**kwargs)
              puts ::Paint[kwargs[:data].to_s, :magenta, :bold] if display?(entity)

              chain.next(**kwargs)
            end

            private

            def display?(entity)
              entity.instance_variable_get(:@display) == true
            end
          end
        end
      end
    end
  end
end
