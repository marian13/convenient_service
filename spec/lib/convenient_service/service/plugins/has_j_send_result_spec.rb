# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".result?" do
      let(:service) do
        Class.new do
          include ConvenientService::Standard::Config
        end
      end

      let(:result) { service.success }

      specify do
        expect { described_class.result?(result) }
          .to delegate_to(described_class::Commands::IsResult, :call)
          .with_arguments(result: result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
