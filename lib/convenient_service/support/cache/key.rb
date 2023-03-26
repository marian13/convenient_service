# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      class Key
        ##
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc]
        # @return [void]
        #
        def initialize(*args, **kwargs, &block)
          @args = args
          @kwargs = kwargs
          @block = block
        end

        ##
        # @param other [Object] Can be any type.
        # @return [Boolean]
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
        # @return [Boolean]
        #
        # @internal
        #   IMPORTANT: `Key` instances are used as Ruby hash keys.
        #
        #   This method is overridden in order to avoid the following case:
        #
        #   hash = {}
        #
        #   ##
        #   # Two equal keys in terms of `==`.
        #   #
        #   first_key = ConvenientService::Common::Plugins::CachesReturnValue::Entities::Key.new(method: :result, args: [], kwargs: {}, block: nil)
        #   second_key = ConvenientService::Common::Plugins::CachesReturnValue::Entities::Key.new(method: :result, args: [], kwargs: {}, block: nil)
        #
        #   first_key == second_key
        #   # => true
        #
        #   hash[first_key] = "value"
        #
        #   hash[second_key]
        #   # => nil # This happens since keys are not equal in terms of `eql?`.
        #
        #   NOTE: Ruby hash and Object#hash are not the same things.
        #   - https://ruby-doc.org/core-3.1.2/Object.html#method-i-hash
        #   - https://belighted.com/blog/overriding-equals-equals/
        #
        def eql?(other)
          return unless other.instance_of?(self.class)

          hash == other.hash
        end

        ##
        # @internal
        #   NOTE: hash is overridden to treat blocks that were defined at the same location as equal.
        #   - https://ruby-doc.org/core-3.1.2/Proc.html#method-i-source_location
        #   - https://ruby-doc.org/core-3.1.2/Object.html#method-i-hash
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
        #   @return [Proc]
        #
        attr_reader :block
      end
    end
  end
end
