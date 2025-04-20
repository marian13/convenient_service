# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module StubService
        ##
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubService]
        #
        def stub_service(...)
          Classes::StubService.call(...)
        end

        ##
        # @param status [Symbol]
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubService::Entities::ResultSpec]
        #
        def return_result(status)
          Classes::StubService::Entities::ResultSpec.new(status: status)
        end

        ##
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubService::Entities::ResultSpec]
        #
        def return_success
          Classes::StubService::Entities::ResultSpec.new(status: :success)
        end

        ##
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubService::Entities::ResultSpec]
        #
        def return_failure
          Classes::StubService::Entities::ResultSpec.new(status: :failure)
        end

        ##
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubService::Entities::ResultSpec]
        #
        def return_error
          Classes::StubService::Entities::ResultSpec.new(status: :error)
        end
      end
    end
  end
end
