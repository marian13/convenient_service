# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @internal
#   NOTE:
#     Copied from `Ibsciss/ruby-middleware` without any logic modification.
#     Version: v0.4.2.
#     - Wrapped in a namespace `ConvenientService::Dependencies::Extractions::RubyMiddleware`.
#     - Replaced `require` into `require_relative`.
#     - Added support of middleware creators.
#
#   - https://github.com/marian13/ruby-middleware/blob/v0.4.2
#   - https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2
#   - https://github.com/Ibsciss/ruby-middleware
#
require_relative "ruby_middleware/middleware"
