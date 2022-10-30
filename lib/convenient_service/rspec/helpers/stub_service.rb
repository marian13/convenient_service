# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module StubService
        def stub_service(...)
          Custom::StubService.call(...)
        end

        def return_result(status)
          Custom::StubService::Entities::ResultSpec.new(status: status)
        end

        def return_success
          Custom::StubService::Entities::ResultSpec.new(status: :success)
        end

        def return_failure
          Custom::StubService::Entities::ResultSpec.new(status: :failure)
        end

        def return_error
          Custom::StubService::Entities::ResultSpec.new(status: :error)
        end
      end
    end
  end
end
