# frozen_string_literal: true

module ConvenientService
  module Support
    class UniqueValue
      ##
      # @!attribute [r] label
      #   @return [String]
      #
      attr_reader :label

      ##
      # @param label [String]
      # @return [void]
      #
      def initialize(label = default_label)
        @label = label
      end

      ##
      # @return [String]
      #
      def inspect
        return "unique_value_#{default_label}" if label.nil?
        return "unique_value_#{default_label}" if label.empty?

        "unique_value_#{label}"
      end

      private

      ##
      # @return [String]
      #
      def default_label
        object_id.to_s
      end
    end
  end
end
