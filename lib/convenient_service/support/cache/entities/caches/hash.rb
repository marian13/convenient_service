# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Hash < Caches::Base
            ##
            # @param store [Hash{Object => Object}]
            # @return [void]
            #
            def initialize(store: {}, **kwargs)
              super(store: ::Hash.new(kwargs[:default]).update(store), **kwargs)
            end

            ##
            # @return [Symbol]
            #
            def backend
              Constants::Backends::HASH
            end

            ##
            # @return [Boolean]
            #
            # @internal
            #   https://ruby-doc.org/core-2.7.0/Hash.html#method-i-empty-3F
            #
            def empty?
              store.empty?
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Boolean]
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-exist-3F
            #
            def exist?(key)
              store.has_key?(key)
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-read
            #
            def read(key)
              store[key]
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
              save_self_as_scope_in_parent!

              store[key] = value
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
              return store[key] unless block

              save_self_as_scope_in_parent!

              store.fetch(key) { store[key] = yield }
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            # @internal
            #   https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-delete
            #
            def delete(key)
              value = store.delete(key)

              delete_self_as_scope_in_parent! if store.empty?

              value
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Caches::Hash]
            #
            def clear
              store.clear

              self
            end

            ##
            # Creates a scoped cache. Parent cache is modified on the first write to the scoped cache.
            #
            # @param key [Object] Can be any type.
            # @param backed_by [Symbol]
            # @param default [Object] Can be any type.
            # @return [ConvenientService::Support::Cache::Entities::Caches::Base]
            #
            # @internal
            #   TODO: Add specs for `default` option transfer.
            #
            def scope(key, backed_by: backend, default: self.default)
              store.fetch(key) { Support::Cache.backed_by(backed_by).new(default: default, parent: self, key: key) }
            end

            ##
            # Creates a scoped cache. Parent cache is modified immediately.
            #
            # @param key [Object] Can be any type.
            # @param backed_by [Symbol]
            # @param default [Object] Can be any type.
            # @return [ConvenientService::Support::Cache::Entities::Caches::Base]
            #
            # @internal
            #   TODO: Add specs for `default` option transfer.
            #
            def scope!(key, backed_by: backend, default: self.default)
              store.fetch(key) { store[key] = Support::Cache.backed_by(backed_by).new(default: default, parent: self, key: key) }
            end

            ##
            # @param value [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def default=(value)
              save_self_as_scope_in_parent!

              store.default = value

              @default = value
            end
          end
        end
      end
    end
  end
end
