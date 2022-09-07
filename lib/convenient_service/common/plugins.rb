# frozen_string_literal: true

##
# NOTE: Order matters.
#
require_relative "plugins/normalizes_env"

require_relative "plugins/caches_constructor_params"
require_relative "plugins/caches_return_value"
require_relative "plugins/can_be_copied"
require_relative "plugins/has_around_callbacks"
require_relative "plugins/has_callbacks"
require_relative "plugins/has_config"
require_relative "plugins/has_constructor"
require_relative "plugins/has_internals"
