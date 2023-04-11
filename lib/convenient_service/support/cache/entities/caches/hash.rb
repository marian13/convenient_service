# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Hash < Caches::Base
            ##
            # @return [void]
            #
            def initialize(hash = {})
              @hash = hash
            end

            ##
            # @return [Hash{Object => Object}]
            #
            def store
              hash
            end

            ##
            # @return [Boolean]
            #
            # @internal
            #   https://ruby-doc.org/core-2.7.0/Hash.html#method-i-empty-3F
            #
            def empty?
              hash.empty?
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Boolean]
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-exist-3F
            #
            def exist?(key)
              hash.has_key?(key)
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-read
            #
            def read(key)
              hash[key]
            end

            ##
            # @param key [Object] Can be any type.
            # @param value [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-write
            #
            def write(key, value)
              hash[key] = value
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
              return hash[key] unless block

              hash.fetch(key) { hash[key] = block.call }
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-delete
            #
            def delete(key)
              hash.delete(key)
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Caches::Hash]
            #
            def clear
              hash.clear

              self
            end

            private

            ##
            # @!attribute [r] hash
            #   @return [Hash]
            #
            attr_reader :hash
          end
        end
      end
    end
  end
end
