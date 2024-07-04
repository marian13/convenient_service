# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".step?" do
      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Essential
          include ConvenientService::Service::Configs::Inspect

          step :result

          def result
            success
          end
        end
      end

      let(:step) { service.new.steps.first }

      specify do
        expect { described_class.step?(step) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Commands::IsStep, :call)
          .with_arguments(step: step)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
