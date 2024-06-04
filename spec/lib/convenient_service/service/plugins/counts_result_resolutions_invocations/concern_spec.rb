# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CountsResultResolutionsInvocations::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::PrimitiveMatchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
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
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config
        include ConvenientService::CodeReviewAutomation::Config
      end
    end

    let(:service_instance) { service_class.new }

    describe "#result_resolutions_counter" do
      specify do
        allow(ConvenientService::Support::Counter).to receive(:new).and_return(instance_double("Counter"))

        expect { service_instance.result_resolutions_counter }
          .to delegate_to(ConvenientService::Support::Counter, :new)
          .without_arguments
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
