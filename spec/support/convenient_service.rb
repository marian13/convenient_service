# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# NOTE: Sometimes it is needed to debug something even before `convenient_service` is loaded.
#
require "convenient_service/dependencies/extractions/b"

require "convenient_service"

ConvenientService.backtrace_cleaner.remove_silencers! if ::ConvenientService.debug?

ConvenientService::Dependencies.require_can_utilize_finite_loop_plugin

ConvenientService::Dependencies.require_rspec_extentions
ConvenientService::Dependencies.require_test_tools

ConvenientService::Dependencies.require_alias
