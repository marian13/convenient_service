# frozen_string_literal: true

module ConvenientService
  module Support
    class NotPassed < Support::UniqueValue
      ##
      # @param value [Object] Can be any type.
      # @return [Boolean]
      #
      def [](value)
        equal?(value)
      end
    end

    ##
    # @return [ConvenientService::Support::UniqueValue]
    #
    NOT_PASSED = Support::NotPassed.new("not_passed")
  end
end
