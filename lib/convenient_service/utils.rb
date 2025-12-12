# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "utils/array"
require_relative "utils/bool"
require_relative "utils/class"
require_relative "utils/hash"
require_relative "utils/kernel"
require_relative "utils/method"
require_relative "utils/module"
require_relative "utils/proc"
require_relative "utils/string"
require_relative "utils/object"

module ConvenientService
  ##
  # Namespace for Convenient Service utilities that can be expressed as "functions".
  #
  # @api private
  # @since 1.0.0
  # @note Utilities from the `Utils` module are NOT expected to be used by the end-users directly.
  # @note Plugin developers usually can rely on the `Utils` module, but it is always a good idea to open an issue with the corresponding usage example. This way, the custom plugin may be added to the CI pipeline. So that any breaking change is caught before the new Convenient Service release.
  #
  module Utils
    class << self
      ##
      # @return [Object] Can be any type.
      #
      def memoize_including_falsy_values(...)
        Object::MemoizeIncludingFalsyValues.call(...)
      end

      ##
      # @return [Object] Can be any type.
      #
      def safe_send(...)
        Object::SafeSend.call(...)
      end

      ##
      # @return [Boolean]
      #
      def to_bool(...)
        Bool::ToBool.call(...)
      end

      ##
      # @return [Object] Can be any type.
      #
      def with_one_time_object(...)
        Object::WithOneTimeObject.call(...)
      end
    end
  end
end
