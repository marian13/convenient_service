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
        # @param service_class [Class<ConvenientService::Service>]
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::StubbedService]
        #
        def stub_service(service_class)
          service_class.stub_result
        end

        ##
        # @param status [Symbol]
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec]
        #
        def return_result(status)
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec.new(status: status)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec]
        #
        def return_success
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec.new(status: :success)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec]
        #
        def return_failure
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec.new(status: :failure)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec]
        #
        def return_error
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultSpec.new(status: :error)
        end
      end
    end
  end
end
