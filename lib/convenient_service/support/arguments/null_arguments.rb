# frozen_string_literal: true

module ConvenientService
  module Support
    class Arguments
      ##
      # @api private
      #
      class NullArguments < Support::Arguments
        ##
        # @return [void]
        #
        def initialize
          @args = []
          @kwargs = {}
          @block = nil
        end

        ##
        # @return [Boolean]
        #
        def null_arguments?
          true
        end
      end
    end
  end
end
