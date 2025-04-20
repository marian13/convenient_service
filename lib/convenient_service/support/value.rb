# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
      # @return [Boolean, nil]
      #
      def ==(other)
        return unless other.instance_of?(self.class)

        label == other.label
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

        label == other.label
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
        "value"
      end
    end
  end
end
