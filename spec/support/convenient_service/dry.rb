# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

ConvenientService::Dependencies.require_development_tools

require "convenient_service/extras/standard/config/options/dry_initializer"

ConvenientService::Dependencies.require_has_j_send_result_params_validations_using_dry_validation_plugin

ConvenientService::Dependencies.require_dry_examples
ConvenientService::Dependencies.require_dry_examples(version: "v1")
