# frozen_string_literal: true

module ConvenientService
  module Utils
    module Proc
      ##
      # @return [Object] Can be any type.
      #
      # @internal
      #   TODO: Specs.
      #
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
          proc.arity == 1 ? proc.call(object) : object.instance_exec(&proc)
        end
      end
    end
  end
end
