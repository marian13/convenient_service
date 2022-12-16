# frozen_string_literal: true

require_relative "object/instance_variable_fetch"
require_relative "object/resolve_type"

module ConvenientService
  module Utils
    module Object
      class << self
        ##
        # @example
        #   ConvenientService::Utils::Object.instance_variable_fetch("abc", :@foo) { :bar }
        #
        def instance_variable_fetch(...)
          InstanceVariableFetch.call(...)
        end

        ##
        # @example
        #   ConvenientService::Utils::Object.resolve_type("foo")
        #
        def resolve_type(...)
          ResolveType.call(...)
        end
      end
    end
  end
end
