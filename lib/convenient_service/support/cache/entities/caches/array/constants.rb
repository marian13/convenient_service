# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Array < Caches::Base
            module Constants
              ##
              # @return [ConvenientService::Support::UniqueValue]
              #
              UNDEFINED = Support::UniqueValue.new("cache_value_undefined")
            end
          end
        end
      end
    end
  end
end
