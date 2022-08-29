# frozen_string_literal: true

require_relative "object/find_own_const"
require_relative "object/resolve_type"

module ConvenientService
  module Utils
    module Object
      class << self
        ##
        # Usage example:
        #
        #   ConvenientService::Utils::Object.find_own_const(Object, :File)
        #   ConvenientService::Utils::Object.find_own_const(Class, :File)
        #
        def find_own_const(object, const_name)
          FindOwnConst.call(object, const_name)
        end

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
