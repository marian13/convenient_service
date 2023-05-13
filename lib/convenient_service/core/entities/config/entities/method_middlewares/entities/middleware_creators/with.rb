# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module MiddlewareCreators
                class With < MiddlewareCreators::Base
                  ##
                  # @!attribute [r] arguments
                  #   @return [ConvenientService::Support::Arguments]
                  #
                  attr_reader :arguments

                  ##
                  # @param kwargs [Hash{Symbol => ConvenientService::Support::Arguments}]
                  # @return [void]
                  #
                  def initialize(**kwargs)
                    super

                    @arguments = kwargs.fetch(:arguments) { Support::Arguments.null_arguments }
                  end

                  ##
                  # @return [Hash{Symbol => ConvenientService::Support::Arguments}]
                  #
                  def extra_kwargs
                    {arguments: arguments}
                  end

                  ##
                  # @param other [Object] Can be any type.
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    super && Utils.to_bool(arguments == other.arguments)
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
