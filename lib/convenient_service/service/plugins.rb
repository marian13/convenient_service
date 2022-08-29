# frozen_string_literal: true

##
# NOTE: Order matters.
#
require_relative "plugins/can_recalculate_result"
require_relative "plugins/has_result"
require_relative "plugins/has_result_method_steps"
require_relative "plugins/has_result_params_validations"
require_relative "plugins/has_result_short_syntax"
require_relative "plugins/has_result_steps"
require_relative "plugins/raises_on_double_result"
require_relative "plugins/wraps_result_in_db_transaction"

##
# NOTE: The following files refer to plugins, that is why they should be required in the end.
#
require_relative "plugins/has_missing_concerns"
