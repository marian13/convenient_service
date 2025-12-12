# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @internal
#   NOTE: Aliases hide the full constants path from the end-users in order to increase DX.
#   - https://en.wikipedia.org/wiki/User_experience#Developer_experience
##

module ConvenientService
  Command = ::ConvenientService::Support::Command
  Concern = ::ConvenientService::Support::Concern
  DependencyContainer = ::ConvenientService::Support::DependencyContainer
  Result = ::ConvenientService::Service::Plugins::HasJSendResult::Entities::Result
end
