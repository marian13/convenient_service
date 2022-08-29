# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesReturnValue
        module Entities
          class Key
            attr_reader :method, :args, :kwargs, :block

            ##
            #
            #
            def initialize(method:, args:, kwargs:, block:)
              @method = method
              @args = args
              @kwargs = kwargs
              @block = block
            end

            ##
            #
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if method != other.method
              return false if args != other.args
              return false if kwargs != other.kwargs
              return false if block&.source_location != other.block&.source_location

              true
            end

            ##
            # IMPORTANT: `Key' instances are used as Ruby hash keys.
            #
            # This method is overridden in order to avoid the following case:
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
            # NOTE: Ruby hash and Object#hash are not the same things.
            # https://ruby-doc.org/core-3.1.2/Object.html#method-i-hash
            # https://belighted.com/blog/overriding-equals-equals/
            def eql?(other)
              return unless other.instance_of?(self.class)

              hash == other.hash
            end

            ##
            # NOTE: hash is overridden to treat blocks that were defined at the same location as equal.
            # https://ruby-doc.org/core-3.1.2/Proc.html#method-i-source_location
            # https://ruby-doc.org/core-3.1.2/Object.html#method-i-hash
            #
            def hash
              [method, args, kwargs, block&.source_location].hash
            end
          end
        end
      end
    end
  end
end
