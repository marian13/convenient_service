# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class StubEntry < Support::Command
          module Constants
            module Triggers
              ##
              # @return [ConvenientService::Support::UniqueValue]
              #
              STUB_ENTRY = Support::UniqueValue.new("STUB_ENTRY")
            end
          end
        end
      end
    end
  end
end
