# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        class Key
          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [void]
          #
          def initialize(*args, **kwargs, &block)
            @args = args
            @kwargs = kwargs
            @block = block
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean, nil]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if args != other.args
            return false if kwargs != other.kwargs
            return false if block&.source_location != other.block&.source_location

            true
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
          #   NOTE: Check specs to clearly understand when exactly Ruby calls `eql?`.
          #
          def eql?(other)
            return unless other.instance_of?(self.class)

            return false if args != other.args
            return false if kwargs != other.kwargs
            return false if block&.source_location != other.block&.source_location

            true
          end

          ##
          # @internal
          #   NOTE: `#hash` is overridden to treat blocks that are defined at the same location as equal.
          #   - https://ruby-doc.org/core-3.1.2/Proc.html#method-i-source_location
          #
          #   IMPORTANT: `Key` instances are used as Ruby hash keys. `#hash` is overridden in order to avoid the following case:
          #
          #     map = {}
          #
          #     ##
          #     # Two equal keys in terms of `==`.
          #     #
          #     first_key = ConvenientService::Common::Plugins::CachesReturnValue::Entities::Key.new(method: :result, args: [], kwargs: {}, block: nil)
          #     second_key = ConvenientService::Common::Plugins::CachesReturnValue::Entities::Key.new(method: :result, args: [], kwargs: {}, block: nil)
          #
          #     first_key == second_key
          #     # => true
          #
          #     map[first_key] = "value"
          #
          #     map[second_key]
          #     # => nil # This happens since keys have different hash numbers (`first_key.hash == second_key.hash` returns `false`).
          #
          #   NOTE: Ruby hash(map) and `Object#hash` are not the same things.
          #   - https://github.com/ruby/ruby/blob/v3_3_0/hash.c#L3719
          #   - https://shopify.engineering/implementing-equality-in-ruby
          #
          #   IMPORTANT: Delegate to `Array#hash` to calculate complex hash number. It is efficient and has lower probability of collision. Any custom hashing requires too much deep thinking.
          #   - https://shopify.engineering/implementing-equality-in-ruby
          #   - https://ruby-doc.org/core-2.7.1/Array.html#method-i-hash
          #
          def hash
            [args, kwargs, block&.source_location].hash
          end

          protected

          ##
          # @!attribute [r] args
          #   @return [Array]
          #
          attr_reader :args

          ##
          # @!attribute [r] kwargs
          #   @return [Hash]
          #
          attr_reader :kwargs

          ##
          # @!attribute [r] block
          #   @return [Proc, nil]
          #
          attr_reader :block
        end
      end
    end
  end
end
