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
          array.any? { |arr_key, _value| arr_key == key }
        end

        ##
        # @return [Object] Can be any type.
        #
        def read(key)
          pair = array.find { |arr_key, _value| arr_key == key }

          pair ? pair[1] : nil
        end

        ##
        # @param key [Object] Can be any type.
        # @param value [Object] Can be any type.
        # @return [Object] Can be any type.
        #
        def write(key, value)
          pair = array.find { |arr_key, _value| arr_key == key }
          
          if pair  
            pair[1] = value
          else
            array << [key, value]
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

          pair ? pair[1] : nil
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
          Support::Cache.set_default_class(true)

          fetch(key) { Support::Cache.default_class.new }
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