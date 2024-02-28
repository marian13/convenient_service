# frozen_string_literal: true

module ConvenientService
  module Support
    class Value
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
      # @param other [Object] Can be any type.
      # @return [Boolean]
      #
      def ==(other)
        return unless other.instance_of?(self.class)

        label == other.label
      end

      ##
      # @param other [Object] Can be any type.
      # @return [Boolean]
      #
      def ===(other)
        self == other
      end

      ##
      # @param other [Object] Can be any type.
      # @return [Boolean]
      #
      def eql?(other)
        return unless other.instance_of?(self.class)

        hash == other.hash
      end

      ##
      # @return [Integer]
      #
      # @internal
      #   IMPORTANT: What to do with collisions?
      #
      def hash
        label.hash
      end

      ##
      # @return [String]
      #
      def inspect
        return default_label if label.nil?
        return default_label if label.empty?

        label
      end

      private

      ##
      # @return [String]
      #
      def default_label
        "value"
      end
    end
  end
end
