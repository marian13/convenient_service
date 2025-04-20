# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "cache/constants"
require_relative "cache/entities"
require_relative "cache/exceptions"

module ConvenientService
  module Support
    class Cache
      class << self
        ##
        # @return [ConvenientService::Support::Cache::Entities::Caches::Base]
        #
        def new(...)
          backed_by(Constants::Backends::DEFAULT).new(...)
        end

        ##
        # @param backend [Symbol]
        # @return [Class<ConvenientService::Support::Cache::Entities::Caches::Base>]
        #
        def backed_by(backend)
          case backend
          when Constants::Backends::ARRAY
            Entities::Caches::Array
          when Constants::Backends::HASH
            Entities::Caches::Hash
          when Constants::Backends::THREAD_SAFE_ARRAY
            Entities::Caches::ThreadSafeArray
          when Constants::Backends::THREAD_SAFE_HASH
            Entities::Caches::ThreadSafeHash
          else
            ::ConvenientService.raise Exceptions::NotSupportedBackend.new(backend: backend)
          end
        end
      end
    end
  end
end
