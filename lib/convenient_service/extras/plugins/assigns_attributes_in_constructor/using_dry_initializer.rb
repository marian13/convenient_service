# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: This file is loaded by `require "convenient_service/extras/plugins/assigns_attributes_in_constructor/using_dry_initializer"`.
# NOTE: This file is expected to be called from app entry points like `initializers` in Rails.
##

require "convenient_service"

ConvenientService::Dependencies.require_assigns_attributes_in_constructor_using_dry_initializer_plugin
