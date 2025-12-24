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
        # Stubs service if it was NOT stubbed before, otherwise - overrides the previous stub.
        #
        # @api public
        # @since 1.0.0
        #
        # @param service_class [Class<ConvenientService::Service>]
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceStub]
        #
        # @example Unstub service with any arguments.
        #   class Service
        #     include ConvenientService::Standard::Config
        #
        #     def result
        #       success
        #     end
        #   end
        #
        #   RSpec.describe Service do
        #     include ConvenientService::RSpec::Helpers::StubService
        #     include ConvenientService::RSpec::Matchers::Results
        #
        #     it "works" do
        #       stub_service(Service).to return_error.with_code(:custom_code)
        #
        #       expect(Service).to be_error.with_code(:custom_code)
        #     end
        #   end
        #
        def stub_service(service_class)
          service_class.stub_result
        end

        ##
        # Unstubs service if it was stubbed before, otherwise - does nothing.
        #
        # @api public
        # @since 1.0.0
        #
        # @param service_class [Class<ConvenientService::Service>]
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ServiceUnstub]
        #
        # @example Unstub service with any arguments.
        #   class Service
        #     include ConvenientService::Standard::Config
        #
        #     def result
        #       success
        #     end
        #   end
        #
        #   RSpec.describe Service do
        #     include ConvenientService::RSpec::Helpers::StubService
        #     include ConvenientService::RSpec::Matchers::Results
        #
        #     it "works" do
        #       stub_service(Service).to return_error.with_code(:custom_code)
        #
        #       unstub_service(Service).to return_result_mock
        #
        #       expect(Service).to be_success.without_data
        #     end
        #   end
        #
        def unstub_service(service_class)
          service_class.unstub_result
        end

        ##
        # @param status [Symbol]
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
        #
        def return_result(status)
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock.new(status: status)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
        #
        def return_success
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock.new(status: :success)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
        #
        def return_failure
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock.new(status: :failure)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock]
        #
        def return_error
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultMock.new(status: :error)
        end

        ##
        # @return [ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock]
        #
        def return_result_mock
          ConvenientService::Service::Plugins::CanHaveStubbedResults::Entities::ResultUnmock.new
        end
      end
    end
  end
end
