##
# @author Ruby Middleware Team <https://github.com/Ibsciss/ruby-middleware>
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
# @see https://github.com/Ibsciss/ruby-middleware
##

module ConvenientService
  module Dependencies
    module Extractions
      module RubyMiddleware
        ##
        # @internal
        #   NOTE:
        #     Copied from `Ibsciss/ruby-middleware` with one logic modification.
        #     Version: v0.4.2.
        #     - Wrapped in a namespace `ConvenientService::Dependencies::Extractions::RubyMiddleware`.
        #     - Added support of middleware creators.
        #
        #   - https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/runner.rb
        #
        module Middleware
          # This is a basic runner for middleware stacks. This runner does
          # the default expected behavior of running the middleware stacks
          # in order, then reversing the order.
          class Runner
            # A middleware which does nothing
            EMPTY_MIDDLEWARE = ->(env) { env }

            # Build a new middleware runner with the given middleware
            # stack.
            #
            # Note: This class usually doesn't need to be used directly.
            # Instead, take a look at using the {Builder} class, which is
            # a much friendlier way to build up a middleware stack.
            #
            # @param [Array] stack An array of the middleware to run.
            def initialize(stack)
              # We need to take the stack of middleware and initialize them
              # all so they call the proper next middleware.
              @kickoff = build_call_chain(stack)
            end

            # Run the middleware stack with the given state bag.
            #
            # @param [Object] env The state to pass into as the initial
            #   environment data. This is usual a hash of some sort.
            def call(env)
              # We just call the kickoff middleware, which is responsible
              # for properly calling the next middleware, and so on and so
              # forth.
              @kickoff.call(env)
            end

            protected

            # This takes a stack of middlewares and initializes them in a way
            # that each middleware properly calls the next middleware.
            def build_call_chain(stack)
              # We need to instantiate the middleware stack in reverse
              # order so that each middleware can have a reference to
              # the next middleware it has to call. The final middleware
              # is always the empty middleware, which does nothing but return.
              stack.reverse.inject(EMPTY_MIDDLEWARE) do |next_middleware, current_middleware|
                # Unpack the actual item
                klass, args, block = current_middleware

                # Default the arguments to an empty array. Otherwise in Ruby 1.8
                # a `nil` args will actually pass `nil` into the class. Not what
                # we want!
                args ||= []

                if klass.is_a?(Class)
                  # If the klass actually is a class, then instantiate it with
                  # the app and any other arguments given.
                  klass.new(next_middleware, *args, &block)
                ##
                # IMPORTANT: Customization compared to the original `Runner` implementation.
                #
                # NOTE: Added support of middleware creators.
                #
                elsif klass.respond_to?(:new)
                  klass.new(next_middleware, *args, &block)
                elsif klass.respond_to?(:call)
                  # Make it a lambda which calls the item then forwards up
                  # the chain.
                  lambda do |env|
                    next_middleware.call(klass.call(env, *args))
                  end
                else
                  fail "Invalid middleware, doesn't respond to `call`: #{klass.inspect}"
                end
              end
            end
          end
        end
      end
    end
  end
end
