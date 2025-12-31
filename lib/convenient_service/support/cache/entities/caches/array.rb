# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "array/entities"

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Array < Caches::Base
            ##
            # @param store [Array<ConvenientService::Support::Cache::Entities::Caches::Array::Entities::Pair>]
            # @return [void]
            #
            def initialize(store: [], **kwargs)
              super(store: ::Array.new(0, kwargs[:default]).concat(store), **kwargs)
            end

            ##
            # @return [Symbol]
            #
            def backend
              Constants::Backends::ARRAY
            end

            ##
            # @return [Boolean]
            #
            def empty?
              store.empty?
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Boolean]
            #
            def exist?(key)
              index(key) ? true : false
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def read(key)
              index = index(key)

              index ? store[index].value : default
            end

            ##
            # @param key [Object] Can be any type.
            # @param value [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def write(key, value)
              index = index(key) || store.size

              save_self_as_scope_in_parent!

              store[index] = pair(key, value)

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
              _fetch(key, default: default, &block)
            end

            ##
            # @param key [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def delete(key)
              index = index(key)

              value = store.delete_at(index).value if index

              delete_self_as_scope_in_parent! if store.empty?

              value
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Caches::Array]
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
              Utils.with_one_time_object do |undefined|
                value = _fetch(key, default: undefined)

                (value == undefined) ? Support::Cache.backed_by(backed_by).new(default: default, parent: self, key: key) : value
              end
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
              _fetch(key) { Support::Cache.backed_by(backed_by).new(default: default, parent: self, key: key) }
            end

            ##
            # @param value [Object] Can be any type.
            # @return [Object] Can be any type.
            #
            def default=(value)
              @default = value

              if value.nil?
                delete_self_as_scope_in_parent! if store.empty?
              else
                save_self_as_scope_in_parent!
              end
            end

            private

            ##
            # @param key [Object] Can be any type.
            # @return [Integer, nil]
            #
            def index(key)
              store.find_index { |pair| pair.key == key }
            end

            ##
            # @param key [Object] Can be any type.
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::Cache::Entities::Caches::Array::Pair]
            #
            def pair(key, value)
              Entities::Pair.new(key: key, value: value)
            end

            ##
            # @param key [Object] Can be any type.
            # @param block [Proc, nil]
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: Inspired by `ActiveSupport::Cache`.
            #   - https://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html#method-i-fetch
            #
            def _fetch(key, default: nil, &block)
              index = index(key)

              return store[index].value if index

              return default unless block

              value = yield

              save_self_as_scope_in_parent!

              store << pair(key, value)

              value
            end
          end
        end
      end
    end
  end
end
