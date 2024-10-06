# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasInspect::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

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

        def self.name
          "ImportantService"
        end
      end
    end

    let(:service_instance) { service_class.new }

    describe "#inspect" do
      it "returns `inspect` representation of service" do
        expect(service_instance.inspect).to eq("<#{service_class.name}>")
      end

      context "when service class is anonymous" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config
          end
        end

        it "uses custom class name" do
          expect(service_instance.inspect).to eq("<AnonymousClass(##{service_class.object_id})>")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
