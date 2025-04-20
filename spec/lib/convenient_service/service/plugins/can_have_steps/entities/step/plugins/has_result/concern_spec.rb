# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Concern, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { step_class }

      let(:step_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Helpers::IgnoringException

    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::Results

    describe "#result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          step "abc"
        end
      end

      let(:service_instance) { service_class.new }

      let(:step) { service_instance.steps.first }

      let(:exception_message) do
        <<~TEXT
          Step `#{step.printable_action}` has unknown type.

          Please, ensure the first `step` argument has NO typos.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Exceptions::StepHasUnknownType`" do
        expect { step.result }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Exceptions::StepHasUnknownType)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Exceptions::StepHasUnknownType) { step.result } }
          .to delegate_to(ConvenientService, :raise)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
