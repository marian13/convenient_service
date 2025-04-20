# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Proc
      class ExecConfig < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @!attribute [r] proc
        #   @return [Proc]
        #
        attr_reader :proc

        ##
        # @param proc [Proc]
        # @param object [Object] Can be any type.
        # @return [void]
        #
        def initialize(proc, object)
          @proc = proc
          @object = object
        end

        ##
        # @return [Object] Can be any type.
        #
        # @example Preparation.
        #   class Foo
        #     class << self
        #       def stack
        #         @stack ||= SomeMiddlewareStack.new
        #       end
        #
        #       def configure(&block)
        #         ConvenientService::Utils::Proc.exec_config(block, stack)
        #       end
        #
        #       def test
        #       end
        #     end
        #   end
        #
        # @example First form - no arguments. Block is executed inside the object context (`stack` in this particular case, see preparation example).
        #   class Foo
        #     configure do
        #       use SomeMiddleware
        #
        #       test # Raises Exception since `test` is NOT defined in `stack`.
        #     end
        #   end
        #
        # @example Second form - one argument. Block is executed in the enclosing context.
        #   class Foo
        #     configure do |stack|
        #       stack.use SomeMiddleware
        #
        #       test # Works.
        #     end
        #   end
        #
        # @note Second form allows to access methods from the enclosing context (like `test` in examples).
        #
        # @internal
        #   TODO: Stronger check whether `proc` receives exactly one mandatory positional argument.
        #
        def call
          proc_has_one_positional_argument? ? proc.call(object) : object.instance_exec(&proc)
        end

        private

        ##
        # @return [Boolean]
        #
        # @internal
        #   NOTE: More about `parameters`, `:req`, `:opt`.
        #   - https://jemma.dev/blog/ruby-method-parameters
        #   - https://ruby-doc.org/core-2.7.0/Proc.html#method-i-parameters
        #   - https://ruby-doc.org/core-2.7.0/Method.html#method-i-parameters
        #
        #   NOTE: `Proc#arity` is ambiguous. It can return `1` for different sets of arguments.
        #   https://ruby-doc.org/core-2.7.0/Proc.html#method-i-arity
        #
        #   For example:
        #     proc { |a| }.arity
        #     # => 1
        #
        #     proc { |a:, b:, c: 0| }.arity
        #     # => 1
        #
        def proc_has_one_positional_argument?
          return false unless proc.parameters.one?

          return false unless acceptable_proc_parameter_types.include?(proc_first_parameter_type)

          true
        end

        ##
        # @return [Array]
        #
        # @note
        #   proc { |a| }.parameters
        #   # => [[:opt, :a]]
        #
        #   proc { |a = 0| }.parameters
        #   [[:opt, :a]]
        #
        #   ->(a) {}.parameters
        #   # => [[:req, :a]]
        #
        #   ->(a = 0) {}.parameters
        #   [[:opt, :a]]
        #
        def acceptable_proc_parameter_types
          proc.lambda? ? [:req, :opt] : [:opt]
        end

        ##
        # @return [Symbol]
        #
        # @internal
        #   See `ConvenientService::Utils::Proc#acceptable_proc_parameter_types` why `first.first`.
        #
        def proc_first_parameter_type
          proc.parameters.first.first
        end
      end
    end
  end
end
