# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "matchers/classes"

##
# @internal
#   NOTE: Primitive matchers.
#
require_relative "matchers/be_descendant_of"
require_relative "matchers/be_direct_descendant_of"
require_relative "matchers/cache_its_value"
require_relative "matchers/delegate_to"
require_relative "matchers/extend_module"
require_relative "matchers/have_abstract_method"
require_relative "matchers/have_alias_method"
require_relative "matchers/have_attr_accessor"
require_relative "matchers/have_attr_reader"
require_relative "matchers/have_attr_writer"
require_relative "matchers/include_in_order"
require_relative "matchers/include_module"
require_relative "matchers/prepend_module"
require_relative "matchers/singleton_prepend_module"

##
# @internal
#   NOTE: Higher-level matchers.
#
require_relative "matchers/call_chain_next"
require_relative "matchers/export"
require_relative "matchers/include_config"
require_relative "matchers/results"

module ConvenientService
  module RSpec
    module Matchers
      include Support::Concern

      included do
        include BeDescendantOf
        include BeDirectDescendantOf
        include CacheItsValue
        include ExtendModule
        include HaveAbstractMethod
        include HaveAliasMethod
        include HaveAttrAccessor
        include HaveAttrReader
        include HaveAttrWriter
        include IncludeInOrder
        include PrependModule
        include SingletonPrependModule

        include CallChainNext
        include DelegateTo
        include Export
        include IncludeConfig
        include IncludeModule
        include Results
      end
    end
  end
end
