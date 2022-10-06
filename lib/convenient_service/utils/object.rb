# frozen_string_literal: true

require_relative "object/resolve_type"

module ConvenientService
  module Utils
    module Object
      class << self
        ##
        # Usage example:
        #
        #   ConvenientService::Utils::Object.resolve_type("foo")
        #
        def resolve_type(object)
          ResolveType.call(object)
        end
      end
    end
  end
end
