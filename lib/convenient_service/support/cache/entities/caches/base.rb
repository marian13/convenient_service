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
            # @return [void]
            #
            def initialize(store = nil)
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
            #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:write).with(key, value).and_call_original` for both `cache[key] = value` and `cache.write(key, value)` in RSpec.
            #
            def []=(...)
              write(...)
            end

            ##
            # @param key [Object] Can be any type.
            # @return [ConvenientService::Support::Cache::Entities::Caches::Base]
            #
            def scope(key)
              fetch(key) { self.class.new }
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
          end
        end
      end
    end
  end
end
