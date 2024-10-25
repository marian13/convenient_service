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
      #   NOTE: The `equal?` method should never be overridden by subclasses as it is used to determine object identity (that is, `a.equal?(b)` if and only if `a` is the same object as `b`).
      #   - https://ruby-doc.org/core-2.7.2/BasicObject.html#method-i-equal-3F
      #
      def ==(other)
        return unless other.instance_of?(self.class)

        equal?(other)
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
      #   IMPORTANT: Do NOT delegate to `==` from `eql?`. When user overrides `==` then it can break `eql?`.
      #   - https://shopify.engineering/implementing-equality-in-ruby
      #   - https://github.com/ruby/ruby/blob/v3_3_0/hash.c#L3719
      #   - https://belighted.com/blog/overriding-equals-equals
      #
      def eql?(other)
        return unless other.instance_of?(self.class)

        object_id == other.object_id
      end

      ##
      # @return [Integer]
      #
      # @internal
      #   NOTE: Common way to implement hash.
      #   - https://shopify.engineering/implementing-equality-in-ruby
      #
      def hash
        [self.class, label].hash
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
