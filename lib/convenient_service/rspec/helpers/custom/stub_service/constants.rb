# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class StubService < Support::Command
          module Constants
            module Triggers
              ##
              # @return [ConvenientService::Support::UniqueValue]
              #
              STUB_SERVICE = Support::UniqueValue.new("STUB_SERVICE")
            end
          end
        end
      end
    end
  end
end
