# frozen_string_literal: true

require_relative "object/instance_variable_delete"
require_relative "object/instance_variable_fetch"
require_relative "object/memoize_including_falsy_values"
require_relative "object/resolve_type"

module ConvenientService
  module Utils
    module Object
      class << self
        ##
        # @example
        #   ConvenientService::Utils::Object.instance_variable_delete("abc", :@foo)
        #
        def instance_variable_delete(...)
          InstanceVariableDelete.call(...)
        end

        ##
        # @example
        #   ConvenientService::Utils::Object.instance_variable_fetch("abc", :@foo) { :bar }
        #
        def instance_variable_fetch(...)
          InstanceVariableFetch.call(...)
        end

        ##
        # @example
        #   object = Object.new.tap { |object| object.instance_eval { self.class.attr_reader :foo } }
        #
        #   ConvenientService::Utils::Object.memoize_including_falsy_values(object, :@foo) { false }
        #
        def memoize_including_falsy_values(...)
          MemoizeIncludingFalsyValues.call(...)
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
