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
            # @return [Object] Can be any type.
            #
            abstract_method :empty?

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
            # @return [Boolean]
            #
            abstract_method :==

            ##
            # @return [void]
            #
            def initialize(store = nil)
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
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
            # @return [ConvenientService::Support::Cache::Entities::Key]
            #
            def keygen(...)
              self.class.keygen(...)
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @return [Object] Can be any type.
            #
            # @internal
            #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:read).with(key).and_call_original` for both `cache[key]` and `cache.read(key)` in RSpec.
            #
            def [](key)
              read(key)
            end

            ##
            # @param key [ConvenientService::Support::Cache::Entities::Key]
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
            # @param key [ConvenientService::Support::Cache::Entities::Key]
            # @return [ConvenientService::Support::Cache::Entities::Caches::Base]
            #
            def scope(key)
              # byebug/

              fetch(key) { self.class.new }
            end
          end
        end
      end
    end
  end
end
