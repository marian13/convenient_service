# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # @abstract Subclass and override {#initialize} and {#call} to implement a Command.
    #
    class Command
      class << self
        ##
        # TODO: Specs.
        #
        def call(...)
          new(...).call
        end

        def [](...)
          call(...)
        end
      end

      ##
      # TODO: Specs. Raise error if not overridden.
      #
      def call
      end

      def [](...)
        call(...)
      end
    end
  end
end
