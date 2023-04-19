# frozen_string_literal: true

module ConvenientService
  module Support
    class Anything
      ##
      # @!attribute [r] label
      #   @return [String]
      #
      attr_reader :label

      ##
      # @!attribute [r] comparator
      #   @return [Proc]
      #
      attr_reader :comparator

      ##
      # @param label [String]
      # @return [void]
      #
      def initialize(label = default_label, &comparator)
        @label = label
        @comparator = comparator || match_everything
      end

      ##
      # @param other [Object] Can be any type.
      # @return [Boolean]
      #
      def ==(other)
        comparator.call(other) || object_id == other.object_id
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
        self == other
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
        "anything_#{object_id}"
      end

      def match_everything
        proc { |_other| true }
      end
    end
  end
end
