# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: This file is loaded by `require "convenient_service/alias"`.
# NOTE: This file is expected to be called from app entry points like `initializers` in Rails.
##

##
# @!visibility private
#
require "convenient_service"

ConvenientService::Dependencies.require_alias

##
# `CS` is just an alias for `ConvenientService`. It becames available by `require "convenient_service/alias"`.
#
# @internal
#   NOTE: Added for visibility in YARD docs.
#
module CS
end
