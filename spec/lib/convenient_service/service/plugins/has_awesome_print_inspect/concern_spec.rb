# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasAwesomePrintInspect::Concern do
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
    describe "#inspect" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Minimal

          include ConvenientService::Configs::AwesomePrintInspect

          def self.name
            "ImportantService"
          end
        end
      end

      let(:service_instance) { service_class.new }

      let(:keywords) { ["ConvenientService", "entity", "Service", "name", "ImportantService"] }

      before do
        ##
        # TODO: Remove when Core implements auto committing from `inspect`.
        #
        service_class.commit_config!
      end

      it "returns `inspect` representation of service" do
        expect(service_instance.inspect).to include(*keywords)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
