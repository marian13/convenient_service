# frozen_string_literal: true

require_relative "array/entities"

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class ThreadSafeArray < Caches::Array
            ##
            # @return [void]
            #
            def initialize(array = [])
              super

              @lock = ::Mutex.new
            end

            ##
            # @return [Boolean]
            #
            def empty?(...)
              @lock.synchronize { super }
            end

            ##
            # @return [Boolean]
            #
            def exist?(...)
              @lock.synchronize { super }
            end

            ##
            # @return [Object] Can be any type.
            #
            def read(...)
              @lock.synchronize { super }
            end

            ##
            # @return [Object] Can be any type.
            #
            def write(...)
              @lock.synchronize { super }
            end

            ##
            # @return [Object] Can be any type.
            #
            def fetch(...)
              @lock.synchronize { super }
            end

            ##
            # @return [Object] Can be any type.
            #
            def delete(...)
              @lock.synchronize { super }
            end

            ##
            # @return [ConvenientService::Support::Cache::Entities::Caches::Array]
            #
            def clear(...)
              @lock.synchronize { super }
            end

            ##
            # @internal
            #   `scope` method from parent delegates to thread-safe `fetch`, that is why child `scope` method does NOT require additional synchronization.
            #
            # def scope(...)
            #   # ...
            # end
            ##
          end
        end
      end
    end
  end
end
