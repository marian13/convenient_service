# frozen_string_literal: true

require_relative "matchers/custom"

require_relative "matchers/be_descendant_of"
require_relative "matchers/be_direct_descendant_of"
require_relative "matchers/cache_its_value"
require_relative "matchers/call_chain_next"
require_relative "matchers/delegate_to"
require_relative "matchers/extend_module"
require_relative "matchers/have_abstract_method"
require_relative "matchers/have_alias_method"
require_relative "matchers/have_attr_accessor"
require_relative "matchers/have_attr_reader"
require_relative "matchers/have_attr_writer"
require_relative "matchers/include_module"
require_relative "matchers/prepend_module"
require_relative "matchers/results"
require_relative "matchers/singleton_prepend_module"

module ConvenientService
  module RSpec
    module Matchers
      include Support::Concern

      included do
        include Matchers::BeDescendantOf
        include Matchers::BeDirectDescendantOf
        include Matchers::CacheItsValue
        include Matchers::CallChainNext
        include Matchers::DelegateTo
        include Matchers::ExtendModule
        include Matchers::HaveAbstractMethod
        include Matchers::HaveAliasMethod
        include Matchers::HaveAttrAccessor
        include Matchers::HaveAttrReader
        include Matchers::HaveAttrWriter
        include Matchers::IncludeModule
        include Matchers::PrependModule
        include Matchers::Results
        include Matchers::SingletonPrependModule
      end
    end
  end
end
