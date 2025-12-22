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
            ##
            # @internal
            #   TODO: Contribute.
            #
            #   NOTE: Minimal `ibsciss-middleware` version - `0.4.2`.
            #   - https://github.com/marian13/ruby-middleware/tree/v0.4.2
            #
            class RubyMiddleware < Dependencies::Extractions::RubyMiddleware::Middleware::Builder
              ##
              # @param opts [Hash]
              # @param block [Proc, nil]
              # @return [void]
              #
              # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L43
              # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L59
              #
              def initialize(opts = {}, &block)
                super

                @middleware_name = opts.fetch(:name) { "Stack" }

                ##
                # https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L174
                #
                self.stack = opts[:stack] if opts.has_key?(:stack)
              end

              ##
              # @return [Boolean]
              #
              def empty?
                stack.empty?
              end

              ##
              # @param some_middleware [#call<Hash>]
              # @return [Boolean]
              #
              #   NOTE: `any?(arg)` compares with `===`. For this method `==` is mandatory.
              #
              # rubocop:disable Performance/RedundantEqualityComparisonBlock
              def has?(some_middleware)
                stack.any? { |middleware| middleware == [some_middleware, [], nil] }
              end
              # rubocop:enable Performance/RedundantEqualityComparisonBlock

              ##
              # @return [Boolean]
              #
              def clear
                stack.clear

                self
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
                dup.use(original).call(env)
              end

              ##
              # @param middleware [#call<Hash>]
              # @param args [Array<Object>]
              # @param block [Proc, nil]
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware]
              #
              # @internal
              #   TODO: Rewrite middleware backend. Consider to use `Array` descendant?
              #
              def unshift(middleware, *args, &block)
                stack.unshift([middleware, args, block])

                self
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware]
              #
              alias_method :prepend, :unshift

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware]
              #
              # @internal
              #   TODO: Direct specs when a `Builder` is passed as argument.
              #
              alias_method :remove, :delete

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::RubyMiddleware]
              #
              # @internal
              #   TODO: Direct specs when a `Builder` is passed as argument.
              #
              alias_method :append, :use

              ##
              # @param other [ConvenientService::Support::Middleware::StackBuilder, Object]
              # @return [Boolean, nil]
              #
              # @internal
              #   TODO: Direct specs.
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if name != other.name
                return false if stack != other.stack

                true
              end

              ##
              # @return [Array]
              #
              # @internal
              #   NOTE: `use` can accept additional arguments and block, that is why `stack` contains tuples like [middleware, args, block].
              #   - https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L76
              #
              #   TODO: better name than just `to_a`.
              #
              def to_a
                stack.map(&:first)
              end

              ##
              # @return [ConvenientService::Support::Middleware::StackBuilder]
              #
              # @internal
              #   TODO: Direct specs.
              #
              def dup
                self.class.new(
                  ##
                  # https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L45
                  #
                  runner_class: @runner_class,
                  ##
                  # https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L46
                  #
                  name: @middleware_name.dup,
                  ##
                  # https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L167
                  #
                  stack: stack.dup
                )
              end
            end
          end
        end
      end
    end
  end
end
