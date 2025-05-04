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
      # @return [Boolean]
      #
      def to_env_bool(...)
        Bool::ToEnvBool.call(...)
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
