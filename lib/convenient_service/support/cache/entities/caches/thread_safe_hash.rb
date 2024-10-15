# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class ThreadSafeHash < Caches::Hash
            ##
            # @return [void]
            #
            def initialize(...)
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
            # @return [ConvenientService::Support::Cache::Entities::Caches::Array]
            #
            def scope(...)
              @lock.synchronize { super }
            end

            ##
            # @note NOT thread-safe.
            #
            # def ==(other)
            #   # ...
            # end
          end
        end
      end
    end
  end
end
