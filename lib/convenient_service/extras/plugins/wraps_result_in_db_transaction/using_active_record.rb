# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: This file is loaded by `require "convenient_service/extras/plugins/wraps_result_in_db_transaction/using_active_record"`.
# NOTE: This file is expected to be called from app entry points like `initializers` in Rails.
##

require "convenient_service"

ConvenientService::Dependencies.require_wraps_result_in_db_transaction_plugin
