# frozen_string_literal: true

require_relative "cache/constants"
require_relative "cache/entities"
require_relative "cache/exceptions"

module ConvenientService
  module Support
    class Cache
      class << self
        ##
        # @param backend [Symbol]
        # @return [ConvenientService::Support::Cache::Entities::Caches::Base]
        #
        def create(backend: Constants::Backends::HASH)
          case backend
          when Constants::Backends::ARRAY
            Entities::Caches::Array.new
          when Constants::Backends::HASH
            Entities::Caches::Hash.new
          when Constants::Backends::THREAD_SAFE_ARRAY
            Entities::Caches::ThreadSafeArray.new
          else
            ::ConvenientService.raise Exceptions::NotSupportedBackend.new(backend: backend)
          end
        end
      end
    end
  end
end
