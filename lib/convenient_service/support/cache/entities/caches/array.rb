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
            # @param key [Object] Can be any type.
            # @return [Boolean]
            #
            def exist?(key)
              index = index(key)

              index ? true : false
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def read(key)
              index = index(key)

              array[index].value if index
            end

            ##
            # @param key [Object] Can be any type.
            # @param value [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def write(key, value)
              index = index(key) || array.size

              array[index] = pair(key, value)

              value
            end

            ##
            # @param key [Object] Can be any type.
            # @param block [Proc, nil]
            # @return [Object] Can be any type.
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-fetch
            #
            def fetch(key, &block)
              index = index(key)

              return array[index].value if index

              return unless block

              value = yield

              array << pair(key, value)

              value
            end

            ##
            # @param key [Object] Can be any type.
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

            private

            ##
            # @!attribute [r] array
            #   @return [Array]
            #
            attr_reader :array

            ##
            # @param key [Object] Can be any type.
            # @return [Integer, nil]
            #
            def index(key)
              array.find_index { |pair| pair.key == key }
            end

            ##
            # @param key [Object] Can be any type.
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
