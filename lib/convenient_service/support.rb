# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "support/value"
require_relative "support/unique_value"

require_relative "support/not_passed"
require_relative "support/undefined"
require_relative "support/never_reach_here"
require_relative "support/block"

require_relative "support/concern"

require_relative "support/abstract_method"
require_relative "support/arguments"
require_relative "support/backtrace_cleaner"
require_relative "support/cache"
require_relative "support/castable"
require_relative "support/command"
require_relative "support/copyable"
require_relative "support/counter"
require_relative "support/delegate"
require_relative "support/dependency_container"
require_relative "support/finite_loop"
require_relative "support/middleware"
require_relative "support/raw_value"
require_relative "support/safe_method"
require_relative "support/thread_safe_counter"

module ConvenientService
  ##
  # Namespace for Convenient Service utilities that can NOT be expressed as "functions".
  #
  # @api private
  # @since 1.0.0
  # @note Utilities from the `Support` module are NOT expected to be used by the end-users directly, but they still may interact with them when the `Support` instances are returned from the Convenient Service public methods.
  # @note Plugin developers usually can rely on the `Support` module, but it is always a good idea to open an issue with the corresponding usage example. This way, the custom plugin may be added to the CI pipeline. So that any breaking change is caught before the new Convenient Service release.
  #
  module Support
  end
end
