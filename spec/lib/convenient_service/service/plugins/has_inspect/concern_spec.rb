# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasInspect::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod

        def self.name
          "Service"
        end
      end
    end
  end

  let(:service_instance) { service_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#inspect" do
      it "returns `inspect` representation of service" do
        expect(service_instance.inspect).to eq("<#{service_class.name}>")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
