# frozen_string_literal: true

module ConvenientService
  module Support
    class Command
      class << self
        ##
        # TODO: Specs.
        #
        # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
        #
        #   def call(...)
        #     new(...).call
        #   end
        #
        def call(*args, **kwargs, &block)
          new(*args, **kwargs, &block).call
        end
      end

      ##
      # TODO: Specs. Raise error if not overridden.
      #
      def call
      end
    end
  end
end
