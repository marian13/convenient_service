# frozen_string_literal: true

require_relative "cache/constants"
require_relative "cache/errors"

require_relative "cache/key"

require_relative "cache/array"
require_relative "cache/hash"

module ConvenientService
  module Support
    class Cache
      class << self
        ##
        # @param backend [Symbol]
        # @return [ConvenientService::Support::Cache]
        #
        def create(backend: Constants::Backends::HASH)
          case backend
          when :array
            Cache::Array.new
          when :hash
            Cache::Hash.new
          else
            raise Errors::NotSupportedBackend.new(backend: backend)
          end
        end
      end
    end
  end
end
