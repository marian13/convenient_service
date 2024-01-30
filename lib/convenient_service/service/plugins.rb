# frozen_string_literal: true

##
# @internal
#   NOTE: Order matters.
#
require_relative "plugins/has_result"
require_relative "plugins/has_negated_result"

require_relative "plugins/has_j_send_result"
require_relative "plugins/has_negated_j_send_result"

require_relative "plugins/can_have_steps"
require_relative "plugins/can_have_sequential_steps"

require_relative "plugins/can_recalculate_result"
require_relative "plugins/can_have_method_steps"
require_relative "plugins/can_have_stubbed_results"
require_relative "plugins/can_have_fallbacks"
require_relative "plugins/collects_services_in_exception"
require_relative "plugins/counts_stubbed_results_invocations"
require_relative "plugins/has_inspect"
require_relative "plugins/has_j_send_result_short_syntax"
require_relative "plugins/has_j_send_result_status_check_short_syntax"
require_relative "plugins/has_mermaid_flowchart"
require_relative "plugins/raises_on_not_result_return_value"
require_relative "plugins/raises_on_double_result"
require_relative "plugins/sets_parent_to_foreign_result"

##
# TODO: Move to dependencies.
#
require_relative "plugins/wraps_result_in_db_transaction"

require_relative "plugins/aliases"
