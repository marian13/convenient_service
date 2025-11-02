# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: This file is loaded by `require "convenient_service/extras/plugins/has_attributes/using_active_model_attributes"`.
# NOTE: This file is expected to be called from app entry points like `initializers` in Rails.
#
# @!visibility private
#
require "convenient_service"

ConvenientService::Dependencies.require_has_attributes_using_active_model_attributes_plugin
