# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      class Array < Cache
        ##
        # @return [void]
        #
        def initialize(array = [])
          @array = array
        end

        class << self
          ##
          # @return [ConvenientService::Support::Cache::Key]
          #
          def keygen(...)
            Cache::Key.new(...)
          end
        end

        ##
        # @return [Boolean]
        #
        def empty?
          array.empty?
        end

        ##
        # @return [Boolean]
        #
        def exist?(key)
          array.any? { |pair| pair.key == key }
        end

        ##
        # @return [Object] Can be any type.
        #
        def read(key)
          pair = array.find { |pair| pair.key == key } || Support::Cache::Array::Pair.null_pair

          pair.value
        end

        ##
        # @param key [Object] Can be any type.
        # @param value [Object] Can be any type.
        # @return [Object] Can be any type.
        #
        def write(key, value)
          pair = array.find { |arr_key, _value| arr_key == key }

          if pair
            pair.value = value
          else
            array << Support::Cache::Array::Pair.new(key: key, value: value)
          end

          value
        end

        ##
        # @param key [Object] Can be any type.
        # @return [Object] Can be any type.
        #
        def delete(key)
          pair = array.find { |arr_key, _value| arr_key == key }

          array.delete(pair) if pair
        end

        ##
        # @param key [Object] Can be any type.
        # @param block [Proc]
        # @return [Object] Can be any type.
        #
        def fetch(key, &block)
          return read(key) unless block

          exist?(key) ? read(key) : write(key, block.call)
        end

        ##
        # @return [ConvenientService::Support::Cache::Array]
        #
        def clear
          array.clear

          self
        end

        ##
        # @return [ConvenientService::Support::Cache::Array]
        #
        def scope(key)
          fetch(key) { Support::Cache.create(type: :array) }
        end

        ##
        # @return [ConvenientService::Support::Cache::Key]
        #
        def keygen(...)
          Array.keygen(...)
        end

        ##
        # @param other [Object] Can be any type.
        # @return [Boolean]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if array != other.array

          true
        end

        protected

        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array
      end
    end
  end
end
