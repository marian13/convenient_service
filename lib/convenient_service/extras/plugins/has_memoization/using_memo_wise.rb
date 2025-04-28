# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: This file is loaded by `require "convenient_service/extras/plugins/has_memoization/using_memo_wise"`.
# NOTE: This file is expected to be called from app entry points like `initializers` in Rails.
##

require "convenient_service"

ConvenientService::Dependencies.require_has_memoization_using_memo_wise_plugin
