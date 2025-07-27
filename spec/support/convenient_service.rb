# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "convenient_service"

ConvenientService.backtrace_cleaner.remove_silencers! if ::ConvenientService.debug?

ConvenientService::Dependencies.require_test_tools

require "convenient_service/extras/rspec"
require "convenient_service/extras/alias"
