# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Concerns
        module Entities
          class Middleware
            module Commands
              class CastMiddleware < Support::Command
                ##
                # @!attribute [r] other
                #   @return [ConvenientService::Support::Concern, Module]
                #
                attr_reader :other

                ##
                # @param other [ConvenientService::Support::Concern, Module]
                # @return [void]
                #
                def initialize(other:)
                  @other = other
                end

                ##
                # @return [ConvenientService::Core::Entities::Concerns::Entities::Middleware, nil]
                #
                def call
                  case other
                  when ::Module
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
                #   IMPORTANT: Must be kept in sync with `def concern` in `ConvenientService::Core::Entities::Concerns::Middleware`.
                #
                def cast_module(mod)
                  ::Class.new(Entities::Middleware).tap do |klass|
                    klass.class_exec(mod) do |mod|
                      ##
                      # @return [ConvenientService::Support::Concern, Module]
                      #
                      define_singleton_method(:concern) { mod }

                      ##
                      # @return [Boolean]
                      #
                      define_singleton_method(:==) { |other| concern == other.concern if other.instance_of?(self.class) }
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
