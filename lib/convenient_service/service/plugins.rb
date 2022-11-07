# frozen_string_literal: true

##
# NOTE: Order matters.
#
require_relative "plugins/caches_repeated_results"
require_relative "plugins/can_recalculate_result"
require_relative "plugins/can_adjust_foreign_results"
require_relative "plugins/has_result"
require_relative "plugins/has_result_method_steps"
require_relative "plugins/has_result_short_syntax"
require_relative "plugins/has_result_steps"
require_relative "plugins/raises_on_double_result"
require_relative "plugins/wraps_result_in_db_transaction"

require_relative "plugins/aliases"
