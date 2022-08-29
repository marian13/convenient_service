# frozen_string_literal: true

require_relative "plugins/can_recalculate_result"
require_relative "plugins/has_result_short_syntax"
require_relative "plugins/marks_result_status_as_checked"
require_relative "plugins/raises_on_not_checked_result_status"

##
# NOTE: The following file refer to plugins, that is why it should be required in the end.
#
require_relative "plugins/has_missing_concerns"
