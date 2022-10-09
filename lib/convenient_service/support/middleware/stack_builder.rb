# frozen_string_literal: true

module ConvenientService
  module Support
    module Middleware
      ##
      # TODO: Contribute.
      #
      # NOTE: Minimal `ibsciss-middleware` version - `0.4.2`.
      # https://github.com/Ibsciss/ruby-middleware/tree/v0.4.2
      #
      class StackBuilder < Extractions::RubyMiddleware::Middleware::Builder
        ##
        # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L43
        #
        def initialize(opts = {}, &block)
          super

          ##
          # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L174
          #
          self.stack = opts[:stack] if opts.has_key?(:stack)
        end

        ##
        # @param [ConvenientService::Support::Middleware::StackBuilder, Object]
        # @return [Boolean, nil]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if stack != other.stack

          true
        end

        ##
        # NOTE: `use` can accept additional arguments and block,
        # that is why `stack` contains tuples like [middleware, args, block].
        # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L76
        #
        # TODO: better name than just `to_a`.
        #
        def to_a
          stack
        end

        def dup
          self.class.new(
            ##
            # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L45
            #
            runner_class: @runner_class,
            ##
            # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L46
            #
            name: @middleware_name.dup,
            ##
            # https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/builder.rb#L167
            #
            stack: stack.dup
          )
        end
      end
    end
  end
end
