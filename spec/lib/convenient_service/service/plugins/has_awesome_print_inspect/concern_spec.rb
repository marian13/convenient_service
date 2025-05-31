# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasAwesomePrintInspect

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
        include ConvenientService::Standard::Config.with(:awesome_print_inspect)

        def self.name
          "ImportantService"
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:keywords) { ["ConvenientService", ":entity", "Service", ":name", "ImportantService"] }

    describe "#inspect" do
      it "returns `inspect` representation of service" do
        expect(service_instance.inspect).to include(*keywords)
      end

      context "when service class is anonymous" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config.with(:awesome_print_inspect)
          end
        end

        let(:keywords) { ["ConvenientService", ":entity", "Service", ":name", "AnonymousClass(##{service_class.object_id})"] }

        it "uses custom class name" do
          expect(service_instance.inspect).to include(*keywords)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
