# frozen_string_literal: true

##
# NOTE: Order matters.
#
require_relative "plugins/can_recalculate_result"
require_relative "plugins/can_have_stubbed_result"
require_relative "plugins/has_inspect"
require_relative "plugins/has_result"
require_relative "plugins/has_result_method_steps"
require_relative "plugins/has_result_short_syntax"
require_relative "plugins/has_result_steps"
require_relative "plugins/raises_on_double_result"
require_relative "plugins/wraps_result_in_db_transaction"
require_relative "plugins/has_result_status_check_short_syntax"

require_relative "plugins/aliases"
