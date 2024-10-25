# frozen_string_literal: true

module ConvenientService
  module Support
    class Undefined < Support::UniqueValue
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
    UNDEFINED = Support::Undefined.new("undefined")
  end
end
