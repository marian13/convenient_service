# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module StubService
        def stub_service(...)
          Classes::StubService.call(...)
        end

        def return_result(status)
          Classes::StubService::Entities::ResultSpec.new(status: status)
        end

        def return_success
          Classes::StubService::Entities::ResultSpec.new(status: :success)
        end

        def return_failure
          Classes::StubService::Entities::ResultSpec.new(status: :failure)
        end

        def return_error
          Classes::StubService::Entities::ResultSpec.new(status: :error)
        end
      end
    end
  end
end
