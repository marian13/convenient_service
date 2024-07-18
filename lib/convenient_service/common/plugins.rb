# frozen_string_literal: true

##
# @internal
#   NOTE: Some plugins are order-dependent.
#
require_relative "plugins/caches_constructor_arguments"
require_relative "plugins/caches_return_value"
require_relative "plugins/can_be_copied"
require_relative "plugins/can_have_user_provided_entity"
require_relative "plugins/ensures_negated_j_send_result"
require_relative "plugins/can_have_callbacks"
require_relative "plugins/has_constructor"
require_relative "plugins/has_constructor_without_initialize"
require_relative "plugins/has_internals"
require_relative "plugins/has_instance_proxy"
require_relative "plugins/has_j_send_result_duck_short_syntax"

require_relative "plugins/aliases"
