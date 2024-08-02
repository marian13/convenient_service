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
      # @param other [Object] Can be any type.
      # @return [Boolean, nil]
      #
      # @internal
      #   NOTE: Every single Ruby object responds to `object_id`.
      #
      def ==(other)
        return unless other.instance_of?(self.class)

        object_id == other.object_id
      end

      ##
      # @param other [Object] Can be any type.
      # @return [Boolean, nil]
      #
      def ===(other)
        self == other
      end

      ##
      # @param other [Object] Can be any type.
      # @return [Boolean, nil]
      #
      # @internal
      #   TODO: What to do in case unique value is used as hash key? See `ConveninetService::Support::Cache::Entities::Key`.
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
        "unique_value_#{object_id}"
      end
    end
  end
end
