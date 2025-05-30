# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "plugins/has_negated_result"
require_relative "plugins/can_be_from_fallback"
require_relative "plugins/can_be_from_exception"
require_relative "plugins/can_be_own_result"
require_relative "plugins/can_be_stubbed_result"
require_relative "plugins/has_j_send_status_and_attributes"
require_relative "plugins/has_inspect"
require_relative "plugins/has_pattern_matching_support"
require_relative "plugins/has_stubbed_result_invocations_counter"
require_relative "plugins/helps_to_learn_similarities_with_common_objects"
require_relative "plugins/can_have_step"
require_relative "plugins/can_have_parent_result"
require_relative "plugins/can_have_checked_status"
require_relative "plugins/raises_on_not_checked_result_status"

require_relative "plugins/aliases"
