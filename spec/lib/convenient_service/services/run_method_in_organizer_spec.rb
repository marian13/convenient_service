# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Services::RunMethodInOrganizer do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:service_result) { described_class.result(method_name: method_name, organizer: organizer, **kwargs) }

      let(:organizer_service_class) do
        Class.new.tap do |klass|
          klass.class_exec(method_name, method_return_value) do |method_name, method_return_value|
            include ConvenientService::Configs::Minimal

            define_method(method_name) { success(data: {value: method_return_value}) }
          end
        end
      end

      let(:method_return_value) { :bar }

      let(:method_name) { :foo }
      let(:organizer) { organizer_service_class.new }
      let(:kwargs) { {} }

      it "calls method in `organizer` context" do
        expect(service_result).to be_success.with_data(value: method_return_value)
      end

      context "when `kwargs` are passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(method_name) do |method_name|
              include ConvenientService::Configs::Minimal

              define_method(method_name) { |**kwargs| success(data: {kwargs: kwargs}) }
            end
          end
        end

        let(:kwargs) { {foo: :bar} }

        it "ignores them" do
          expect(service_result).to be_success.with_data(kwargs: {})
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#inspect_values" do
      let(:organizer_service_class) do
        Class.new do
          include ConvenientService::Configs::Minimal

          def self.name
            "Service"
          end
        end
      end

      let(:organizer_service_instance) { organizer_service_class.new }
      let(:service) { described_class.new(method_name: :foo, organizer: organizer_service_instance) }
      let(:inspect_values) { {name: "Service::RunMethod(:foo)"} }

      it "returns inspect values" do
        expect(service.inspect_values).to eq(inspect_values)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
