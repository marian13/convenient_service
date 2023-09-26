# frozen_string_literal: true

require_relative "primitive_matchers/classes"

require_relative "primitive_matchers/be_descendant_of"
require_relative "primitive_matchers/be_direct_descendant_of"
require_relative "primitive_matchers/cache_its_value"
require_relative "primitive_matchers/delegate_to"
require_relative "primitive_matchers/extend_module"
require_relative "primitive_matchers/have_abstract_method"
require_relative "primitive_matchers/have_alias_method"
require_relative "primitive_matchers/have_attr_accessor"
require_relative "primitive_matchers/have_attr_reader"
require_relative "primitive_matchers/have_attr_writer"
require_relative "primitive_matchers/include_module"
require_relative "primitive_matchers/prepend_module"
require_relative "primitive_matchers/singleton_prepend_module"

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      include Support::Concern

      included do
        include BeDescendantOf
        include BeDirectDescendantOf
        include CacheItsValue
        include DelegateTo
        include ExtendModule
        include HaveAbstractMethod
        include HaveAliasMethod
        include HaveAttrAccessor
        include HaveAttrReader
        include HaveAttrWriter
        include IncludeModule
        include PrependModule
        include SingletonPrependModule
      end
    end
  end
end
