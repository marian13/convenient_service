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
            # @return [Boolean]
            #
            # @internal
            #   https://ruby-doc.org/core-2.7.0/Hash.html#method-i-empty-3F
            #
            def empty?
              hash.empty?
            end

            ##
            # @return [Boolean]
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-exist-3F
            #
            def exist?(key)
              hash.has_key?(key)
            end

            ##
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

            ##
            # @return [ConvenientService::Support::Cache::Entities::Caches::Hash]
            #
            def scope(key)
              fetch(key) { Hash.new }
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if hash != other.hash

              true
            end

            protected

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