# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Base
            include Support::AbstractMethod

            class << self
              ##
              # @return [ConvenientService::Support::Cache::Entities::Key]
              #
              def keygen(...)
                Entities::Key.new(...)
              end
            end

            ##
            # @!attribute [r] store
            #   @return [Object]
            #
            attr_reader :store

            ##
            # @!attribute [r] default
            #   @return [Object] Can be any type.
            #
            attr_reader :default

            ##
            # @note `parent` is only present when cache is scoped.
            #
            # @!attribute [r] parent
            #   @return [ConvenientService::Support::Cache::Entities::Caches::Base, nil]
            #
            attr_reader :parent

            ##
            # @note `key` is only present when cache is scoped.
            #
            # @!attribute [r] key
            #   @return [ConvenientService::Support::Cache::Entities::Key, Object]
            #
            attr_reader :key

            ##
            # @return [Boolean]
            #
            abstract_method :empty?

            ##
            # @return [Boolean]
            #
            abstract_method :exist?

            ##
            # @return [Object] Can be any type.
            #
            abstract_method :read

            ##
            # @return [Object] Can be any type.
            #
            abstract_method :write

            ##
            # @return [Object] Can be any type.
            #
            abstract_method :fetch

            ##
            # @return [Object, nil] Can be any type.
            #
            abstract_method :delete

            ##
            # @return [ConvenientService::Support::Cache::Enitities::Caches::Base]
            #
            abstract_method :clear

            ##
            # @return [ConvenientService::Support::Cache::Enitities::Caches::Base]
            #
            abstract_method :scope

            ##
            # @return [ConvenientService::Support::Cache::Enitities::Caches::Base]
            #
            abstract_method :scope!

            ##
            # @return [Object] Can be any type.
            #
            abstract_method :default=

            ##
            # @param store [Object] Can be any type.
            # @param default [Object] Can be any type.
            # @param parent [ConvenientService::Support::Cache::Entities::Caches::Base, nil]
            # @param key [ConvenientService::Support::Cache::Entities::Key, Object]
            # @return [void]
            #
            def initialize(store: nil, default: nil, parent: nil, key: nil)
              @store = store
              @default = default
              @parent = parent
              @key = key
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Key]
            #
            def keygen(...)
              self.class.keygen(...)
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:read).with(key).and_call_original` for both `cache[key]` and `cache.read(key)` in RSpec.
            #
            def [](...)
              read(...)
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:read).with(key).and_call_original` for both `cache.get(key)` and `cache.read(key)` in RSpec.
            #
            def get(...)
              read(...)
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:write).with(key, value).and_call_original` for both `cache[key] = value` and `cache.write(key, value)` in RSpec.
            #
            def []=(...)
              write(...)
            end

            ##
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:write).with(key, value).and_call_original` for both `cache.set(key, value)` and `cache.write(key, value)` in RSpec.
            #
            def set(...)
              write(...)
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if store != other.store

              true
            end

            private

            ##
            # @return [void]
            #
            def save_self_as_scope_in_parent!
              parent&.fetch(key) { self }
            end

            ##
            # @return [void]
            #
            def delete_self_as_scope_in_parent!
              parent&.delete(key)
            end
          end
        end
      end
    end
  end
end
