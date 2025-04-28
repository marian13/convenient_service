# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: This file is loaded by `require "convenient_service/extras/standard/config/options/active_model_validations"`.
# NOTE: This file is expected to be called from app entry points like `initializers` in Rails.
##

require "convenient_service"

ConvenientService::Dependencies.require_active_model_validations_standard_config_option
