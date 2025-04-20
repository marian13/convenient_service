# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "expressions/base"

require_relative "expressions/empty"
require_relative "expressions/scalar"
require_relative "expressions/not"
require_relative "expressions/and"
require_relative "expressions/or"
require_relative "expressions/group"

require_relative "expressions/if"
require_relative "expressions/else"
require_relative "expressions/complex_if"
