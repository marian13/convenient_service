# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class WithPins < Custom
              ##
              # @!attribute [r] stacks
              #   @return [Hash{Object => Array<#call<Hash>>}]
              #
              attr_reader :stacks

              ##
              # @param kwargs [Hash{Symbol => Object}]
              # @return [void]
              #
              def initialize(**kwargs)
                @name = kwargs.fetch(:name) { "StackWithPins" }
                @stacks = kwargs.fetch(:stacks) { [:top, :middle, :bottom].reduce({}) { |hash, key| hash[key] = Support::Middleware::StackBuilder.new } }
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware, ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Rack, ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful]
              #
              def merged_stacks
                stacks[:top].merge(stacks[:middle]).merge(stacks[:bottom])
              end

              ##
              # @param env [Hash{Symbol => Object}]
              # @param original [Proc]
              # @return [Object] Can be any type.
              #
              # @internal
              #   TODO: Direct specs.
              #
              def call_with_original(env, original)
                merged_stacks.call_with_original(env, original)
              end

              ##
              # @param env [Hash{Symbol => Object}]
              # @return [Object] Can be any type.
              #
              # @see https://github.com/rack/rack/blob/v3.1.7/lib/rack/builder.rb#L268
              # @see https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/runner.rb#L7
              #
              # @internal
              #   NOTE: When stack is empty - `env` is returned. Just like `ruby-middleware` does.
              #   NOTE: `reduce` for empty array returns initial value.
              #
              #   TODO: Direct specs.
              #
              def call(env)
                merged_stacks.call(env)
              end

              ##
              # @return [Boolean]
              #
              def empty?(pin: :all)
                pin == :all ? stacks.all?(&:empty?) : stacks[pin].empty?
              end

              ##
              # @param some_middleware [#call<Hash>]
              # @return [Boolean]
              #
              #   NOTE: `any?(arg)` compares with `===`. For this method `==` is mandatory.
              #
              # rubocop:disable Performance/RedundantEqualityComparisonBlock
              def has?(some_middleware, pin: :all)
                if pin == :all
                  stacks.any? { |stack| stack.any? { |middleware| middleware == some_middleware } }
                else
                  stacks[pin].any? { |middleware| middleware == some_middleware }
                end
              end
              # rubocop:enable Performance/RedundantEqualityComparisonBlock

              ##
              # @return [Boolean]
              #
              def clear(pin: :all)
                pin == :all ? stacks.all?(&:clear) : stacks[pin].clear

                self
              end

              ##
              # @param middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              def unshift(middleware, pin: :middle)
                stacks[pin].unshift(middleware)

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              alias_method :prepend, :unshift

              ##
              # @param middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              def use(middleware, pin: :middle)
                stacks[pin] << middleware

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              alias_method :append, :use

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom::Exceptions::MissingMiddleware]
              #
              def insert(index_or_middleware, other_middleware, pin: :middle)
                index = cast_index(index_or_middleware, pin)

                stacks[pin].insert(index, other_middleware)

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              alias_method :insert_before, :insert

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom::Exceptions::MissingMiddleware]
              #
              def insert_after(index_or_middleware, other_middleware, pin: :middle)
                index = cast_index(index_or_middleware, pin)

                stacks[pin].insert(index + 1, other_middleware)

                self
              end

              ##
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              def insert_before_each(other_middleware, pin: :middle)
                @stacks[pin] = stacks[pin].reduce([]) { |stack, middleware| stack.push(other_middleware, middleware) }

                self
              end

              ##
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              def insert_after_each(other_middleware, pin: :middle)
                @stacks[pin] = stacks[pin].reduce([]) { |stack, middleware| stack.push(middleware, other_middleware) }

                self
              end

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @param other_middleware [#call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom::Exceptions::MissingMiddleware]
              #
              def replace(index_or_middleware, other_middleware, pin: :middle)
                index = cast_index(index_or_middleware, pin)

                stacks[pin][index] = other_middleware

                self
              end

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom::Exceptions::MissingMiddleware]
              #
              def delete(index_or_middleware, pin: :middle)
                index = cast_index(index_or_middleware, pin)

                stacks[pin].delete_at(index)

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              alias_method :remove, :delete

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if name != other.name
                return false if stacks != other.stacks

                true
              end

              ##
              # @return [Array]
              #
              def to_a
                merged_stacks.to_a
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom]
              #
              def dup
                self.class.new(name: name.dup, stacks: stacks.transform_values(&:dup))
              end

              private

              ##
              # @param index_or_middleware [Integer, #call<Hash>]
              # @return [Integer]
              # @raise [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Custom::Exceptions::MissingMiddleware]
              #
              def cast_index(index_or_middleware, pin: :middle)
                return index_or_middleware if index_or_middleware.instance_of?(Integer)

                index = stacks[pin].find_index { |middleware| middleware == index_or_middleware }

                ::ConvenientService.raise Exceptions::MissingMiddleware.new(middleware: index_or_middleware) unless index

                index
              end
            end
          end
        end
      end
    end
  end
end
