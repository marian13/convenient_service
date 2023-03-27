# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class MiddlewareCreator
                ##
                # @!attribute [r] middleware
                #   @return [Class]
                #
                attr_reader :middleware

                ##
                # @!attribute [r] arguments
                #   @return [ConvenientService::Support::Arguments]
                #
                attr_reader :arguments

                ##
                # @param middleware [Class]
                # @param arguments [ConvenientService::Support::Arguments]
                # @return [void]
                #
                def initialize(middleware:, arguments:)
                  @middleware = middleware
                  @arguments = arguments
                end

                ##
                # @param other [Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if middleware != other.middleware
                  return false if arguments != other.arguments

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end
