# frozen_string_literal: true

require_relative "object/clamp_class"
require_relative "object/duck_class"
require_relative "object/get_own_method"
require_relative "object/instance_variable_delete"
require_relative "object/instance_variable_fetch"
require_relative "object/memoize_including_falsy_values"
require_relative "object/resolve_type"
require_relative "object/safe_send"
require_relative "object/with_one_time_object"

module ConvenientService
  module Utils
    module Object
      class << self
        ##
        # @example
        #   ConvenientService::Utils::Object.clamp_class("foo")
        #
        def clamp_class(...)
          ClampClass.call(...)
        end

        ##
        # @example
        #   ConvenientService::Utils::Object.duck_class("foo")
        #
        def duck_class(...)
          DuckClass.call(...)
        end

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
        #   ConvenientService::Utils.memoize_including_falsy_values(object, :@foo) { false }
        #
        def memoize_including_falsy_values(...)
          MemoizeIncludingFalsyValues.call(...)
        end

        ##
        # @example
        #   object = Object.new.tap { |object| object.instance_eval { self.class.attr_reader :foo } }
        #
        #   ConvenientService::Utils::Object.own_method(object, :foo)
        #   # => #<Method: #<Object:0x0000555e524252d8>.foo() ...>
        #
        #   ConvenientService::Utils::Object.own_method(object, :puts)
        #   # => nil
        #
        def own_method(...)
          GetOwnMethod.call(...)
        end

        ##
        # @example
        #   ConvenientService::Utils::Object.resolve_type("foo")
        #
        def resolve_type(...)
          ResolveType.call(...)
        end

        ##
        # @example
        #   ConvenientService::Utils::Object.safe_send(object, method, *args, **kwargs, &block)
        #
        def safe_send(...)
          SafeSend.call(...)
        end

        ##
        # @example
        #   ConvenientService::Utils::Object.with_one_time_object { |one_time_object| puts one_time_object }
        #
        def with_one_time_object(...)
          WithOneTimeObject.call(...)
        end
      end
    end
  end
end
