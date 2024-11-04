# frozen_string_literal: true

##
# @internal
#   NOTE: Some plugins are order-dependent.
#
require_relative "plugins/has_result"
require_relative "plugins/has_negated_result"

require_relative "plugins/has_j_send_result"
require_relative "plugins/has_negated_j_send_result"

require_relative "plugins/can_have_steps"
require_relative "plugins/can_have_sequential_steps"
require_relative "plugins/can_have_connected_steps"

require_relative "plugins/can_have_after_step_callbacks"
require_relative "plugins/can_have_around_step_callbacks"
require_relative "plugins/can_have_before_step_callbacks"
require_relative "plugins/can_have_fallbacks"
require_relative "plugins/can_have_rollbacks"
require_relative "plugins/can_have_stubbed_results"
require_relative "plugins/can_not_be_inherited"
require_relative "plugins/can_have_recalculations"
require_relative "plugins/collects_services_in_exception"
require_relative "plugins/counts_stubbed_results_invocations"
require_relative "plugins/forbids_convenient_service_entities_as_constructor_arguments"
require_relative "plugins/has_inspect"
require_relative "plugins/has_j_send_result_short_syntax"
require_relative "plugins/has_j_send_result_status_check_short_syntax"
require_relative "plugins/has_mermaid_flowchart"
require_relative "plugins/raises_on_not_result_return_value"
require_relative "plugins/raises_on_double_result"
require_relative "plugins/rescues_result_unhandled_exceptions"
require_relative "plugins/sets_parent_to_foreign_result"

require_relative "plugins/aliases"
