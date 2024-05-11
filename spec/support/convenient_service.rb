# frozen_string_literal: true

##
# NOTE: Sometimes it is needed to debug something even before `convenient_service` is loaded.
#
require "convenient_service/dependencies/extractions/b"

require "convenient_service"

ConvenientService.backtrace_cleaner.remove_silencers! if ::ConvenientService.debug?

ConvenientService::Dependencies.require_can_utilize_finite_loop
ConvenientService::Dependencies.require_awesome_print_inspect
ConvenientService::Dependencies.require_amazing_print_inspect
ConvenientService::Dependencies.require_rescues_result_unhandled_exceptions

ConvenientService::Dependencies.require_rspec_extentions
ConvenientService::Dependencies.require_test_tools

ConvenientService::Dependencies.require_alias
