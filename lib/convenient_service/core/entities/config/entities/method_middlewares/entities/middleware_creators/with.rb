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
                  # @!attribute [r] middleware_arguments
                  #   @return [ConvenientService::Support::Arguments]
                  #
                  attr_reader :middleware_arguments

                  ##
                  # @param kwargs [Hash{Symbol => ConvenientService::Support::Arguments}]
                  # @return [void]
                  #
                  def initialize(**kwargs)
                    super

                    @middleware_arguments = kwargs.fetch(:middleware_arguments) { Support::Arguments.null_arguments }
                  end

                  ##
                  # @return [Hash{Symbol => ConvenientService::Support::Arguments}]
                  #
                  def extra_kwargs
                    {middleware_arguments: middleware_arguments}
                  end

                  ##
                  # @param other [Object] Can be any type.
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    super && Utils.to_bool(middleware_arguments == other.middleware_arguments)
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
