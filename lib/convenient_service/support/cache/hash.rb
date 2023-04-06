# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      class Hash < Cache
        ##
        # @return [void]
        #
        def initialize(hash = {})
          @hash = hash
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
        # @param key [Object] Can be any type.
        # @param block [Proc, nil]
        # @return [Object] Can be any type.
        #
        # @internal
        #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-fetch
        #
        def fetch(key, &block)
          return read(key) unless block

          exist?(key) ? read(key) : write(key, block.call)
        end

        ##
        # @return [ConvenientService::Support::Cache::Hash]
        #
        def clear
          hash.clear

          self
        end

        ##
        # @return [ConvenientService::Support::Cache::Hash]
        #
        def scope(key)
          fetch(key) { Support::Cache.create(type: :hash) }
        end

        ##
        # @return [ConvenientService::Support::Cache::Key]
        #
        def keygen(...)
          Hash.keygen(...)
        end

        ##
        # @return [Object] Can be any type.
        #
        # @internal
        #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:read).with(key).and_call_original` for both `cache[key]` and `cache.read(key)` in RSpec.
        #
        def [](key)
          read(key)
        end

        ##
        # @param key [Object] Can be any type.
        # @param value [Object] Can be any type.
        # @return [Object] Can be any type.
        #
        # @internal
        #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:write).with(key, value).and_call_original` for both `cache[key] = value` and `cache.write(key, value)` in RSpec.
        #
        def []=(key, value)
          write(key, value)
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
