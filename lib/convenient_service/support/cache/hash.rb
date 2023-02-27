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
        # @param block [Proc]
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
          Support::Cache.set_default_class(false)

          fetch(key) { Support::Cache.default_class.new }
        end

        ##
        # @return [ConvenientService::Support::Cache::Key]
        #
        def keygen(...)
          Hash.keygen(...)
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
