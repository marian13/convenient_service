# frozen_string_literal: true

module ConvenientService
  module Support
    module Middleware
      ##
      # @internal
      #   TODO: Contribute.
      #
      #   NOTE: Minimal `ibsciss-middleware` version - `0.4.2`.
      #   https://github.com/marian13/ruby-middleware/tree/v0.4.2
      #
      class StackBuilder < Dependencies::Extractions::RubyMiddleware::Middleware::Builder
        ##
        # @param opts [Hash]
        # @param block [Proc, nil]
        # @return [void]
        #
        # @see https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L43
        #
        # @internal
        #   TODO: Direct specs.
        #
        def initialize(opts = {}, &block)
          super

          ##
          # https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L174
          #
          self.stack = opts[:stack] if opts.has_key?(:stack)
        end

        ##
        # @param middleware [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
        # @param args [Array<Object>]
        # @param block [Proc, nil]
        # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
        #
        # @internal
        #   TODO: Rewrite middleware backend. Consider to use `Array` descendant?
        #
        def unshift(middleware, *args, &block)
          stack.unshift([middleware, args, block])

          self
        end

        ##
        # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
        #
        alias_method :prepend, :unshift

        ##
        # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Stack]
        #
        # @internal
        #   TODO: Direct specs.
        #
        alias_method :remove, :delete

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
        #   https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L76
        #
        #   TODO: better name than just `to_a`.
        #
        def to_a
          stack
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
