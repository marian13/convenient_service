# frozen_string_literal: true

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class Rack
              module Exceptions
                class MissingMiddleware < ::ConvenientService::Exception
                  ##
                  # @param middleware [#call<Hash>]
                  # @return [void]
                  #
                  def initialize_with_kwargs(middleware:)
                    message = <<~TEXT
                      Middleware `#{middleware.inspect}` is NOT found in the stack.
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
end
