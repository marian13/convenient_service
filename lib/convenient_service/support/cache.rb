# frozen_string_literal: true

require_relative "cache/constants"
require_relative "cache/entities"
require_relative "cache/errors"

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
          when :array
            Cache::Entities::Caches::Array.new
          when :hash
            Cache::Entities::Caches::Hash.new
          else
            raise Errors::NotSupportedBackend.new(backend: backend)
          end
        end
      end
    end
  end
end
