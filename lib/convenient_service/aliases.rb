# frozen_string_literal: true

##
# @internal
#   NOTE: Aliases hide the full constants path from the end-users in order to increase DX.
#   - https://en.wikipedia.org/wiki/User_experience#Developer_experience
#
module ConvenientService
  Command = ::ConvenientService::Support::Command
  Concern = ::ConvenientService::Support::Concern
  DependencyContainer = ::ConvenientService::Support::DependencyContainer
end
