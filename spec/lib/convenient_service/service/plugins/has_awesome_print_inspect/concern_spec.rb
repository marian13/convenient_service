# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::AwesomePrintInspect::Config

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasAwesomePrintInspect::Concern, type: :awesome_print do
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
        include ConvenientService::Service::Configs::AwesomePrintInspect

        def self.name
          "ImportantService"
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:inspect_values) { {name: service_class.name} }
    let(:keywords) { ["ConvenientService", ":entity", "Service", ":name", "ImportantService"] }

    describe "#inspect" do
      it "returns `inspect` representation of service" do
        expect(service_instance.inspect).to include(*keywords)
      end

      specify do
        allow(service_instance).to receive(:inspect_values).and_return(inspect_values)

        expect { service_instance.inspect }
          .to delegate_to(service_instance.inspect_values, :[])
          .with_arguments(:name)
      end
    end

    describe "#inspect_values" do
      it "returns `inspect` values" do
        expect(service_instance.inspect_values).to eq(inspect_values)
      end

      context "when service class is anonymous" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config
            include ConvenientService::Service::Configs::AwesomePrintInspect
          end
        end

        it "uses custom class name" do
          expect(service_instance.inspect_values[:name]).to eq("AnonymousClass(##{service_class.object_id})")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
