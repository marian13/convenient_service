# frozen_string_literal: true

##
# NOTE: Sometimes it is needed to debug something even before `convenient_service` is loaded.
#
require_relative "../../lib/convenient_service/dependencies/extractions/b"

require "convenient_service"

ConvenientService.backtrace_cleaner.remove_silencers! if ::ConvenientService.debug?

ConvenientService::Dependencies.require_can_utilize_finite_loop
ConvenientService::Dependencies.require_awesome_print_inspect
ConvenientService::Dependencies.require_rescues_result_unhandled_exceptions
ConvenientService::Dependencies.require_cleans_exception_backtrace

ConvenientService::Dependencies.require_rspec_extentions
ConvenientService::Dependencies.require_test_tools
ConvenientService::Dependencies.require_development_tools

ConvenientService::Dependencies.require_standard_examples
ConvenientService::Dependencies.require_standard_examples(version: "v1")

ConvenientService::Dependencies.require_alias
