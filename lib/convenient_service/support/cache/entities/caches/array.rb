# frozen_string_literal: true

require_relative "array/entities"

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Array < Caches::Base
            ##
            # @return [void]
            #
            def initialize(array = [])
              @array = array
            end

            ##
            # @return [Array<ConvenientService::Support::Cache::Entities::Caches::Array::Entities::Pair>]
            #
            def store
              array
            end

            ##
            # @return [Boolean]
            #
            def empty?
              array.empty?
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @return [Boolean]
            #
            def exist?(key)
              index = index(key)

              index ? true : false
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @return [Object] Can be any type.
            #
            def read(key)
              index = index(key)

              array[index].value if index
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @param value [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def write(key, value)
              index = index(key) || array.size

              array[index] = pair(key, value)

              value
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @return [Object] Can be any type.
            #
            def delete(key)
              index = index(key)

              array.delete_at(index).value if index
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Caches::Array]
            #
            def clear
              array.clear

              self
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

            private

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @return [Integer, nil]
            #
            def index(key)
              array.find_index { |pair| pair.key == key }
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::Cache::Entities::Caches::Array::Pair]
            #
            def pair(key, value)
              Entities::Pair.new(key: key, value: value)
            end
          end
        end
      end
    end
  end
end
