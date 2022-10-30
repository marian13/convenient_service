# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class Concerns
            module Entities
              class Middleware
                module Commands
                  class CastMiddleware < Support::Command
                    ##
                    # @!attribute [r] other
                    #   @return [Module, ConvenientService::Support::Concern]
                    #
                    attr_reader :other

                    ##
                    # @param other [Module, ConvenientService::Support::Concern, ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware]
                    # @return [void]
                    #
                    def initialize(other:)
                      @other = other
                    end

                    ##
                    # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware, nil]
                    #
                    def call
                      if other.instance_of?(Class) && other < Entities::Middleware
                        cast_middleware(other)
                      elsif other.instance_of?(Module)
                        cast_module(other)
                      end
                    end

                    private

                    ##
                    # @internal
                    #   NOTE: `ruby-middleware` expects a `Class` or object that responds to `call`.
                    #   https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/runner.rb#L52
                    #   https://github.com/Ibsciss/ruby-middleware#middleware-lambdas
                    #
                    #   IMPORTANT: Must be kept in sync with `def concern` in `ConvenientService::Core::Entities::Config::Entities::Concerns::Middleware`.
                    #
                    def cast_module(mod)
                      middleware = ::Class.new(Entities::Middleware)

                      ##
                      # @return [Module, ConvenientService::Support::Concern]
                      #
                      middleware.define_singleton_method(:concern) { mod }

                      middleware
                    end

                    def cast_middleware(middleware)
                      middleware.dup
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
end
