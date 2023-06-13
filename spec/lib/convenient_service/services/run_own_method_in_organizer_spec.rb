# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Services::RunOwnMethodInOrganizer do
  example_group "errors" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    specify { expect(described_class::Errors::MethodForStepIsNotDefined).to be_descendant_of(ConvenientService::Error) }
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:service_result) { described_class.result(method_name: method_name, organizer: organizer, **kwargs) }

      let(:prepend_module) do
        Module.new.tap do |mod|
          mod.module_exec(method_name) do |method_name|
            define_method(method_name) { failure }
          end
        end
      end

      let(:method_name) { :foo }
      let(:organizer) { organizer_service_class.new }
      let(:kwargs) { {} }

      context "when `organizer` does NOT have own method" do
        let(:organizer_service_class) do
          Class.new do
            include ConvenientService::Configs::Minimal
          end
        end

        let(:error_message) do
          <<~TEXT
            Service `#{organizer.class}` tries to use `#{method_name}` method in a step, but it is NOT defined.

            Did you forget to define it?
          TEXT
        end

        it "raises `ConvenientService::Services::RunOwnMethodInOrganizer::Errors::MethodForStepIsNotDefined`" do
          expect { service_result }
            .to raise_error(ConvenientService::Services::RunOwnMethodInOrganizer::Errors::MethodForStepIsNotDefined)
            .with_message(error_message)
        end
      end

      context "when `organizer` has own method" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(prepend_module, method_name) do |prepend_module, method_name|
              include ConvenientService::Configs::Minimal

              define_method(method_name) { success }

              ##
              # NOTE: Used to confirm that own is called, not prepended method.
              #
              prepend prepend_module
            end
          end
        end

        it "calls that own method" do
          ##
          # NOTE: Own method returns `success`, while prepended returns `failure`.
          # See `organizer_service_class` definition above.
          #
          expect(service_result).to be_success
        end

        context "when `kwargs` are passed" do
          # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(prepend_module, method_name) do |prepend_module, method_name|
                include ConvenientService::Configs::Minimal

                define_method(method_name) { |**kwargs| success(data: {kwargs: kwargs}) }

                ##
                # NOTE: Used to confirm that own is called, not prepended method.
                #
                prepend prepend_module
              end
            end
          end
          # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

          let(:kwargs) { {foo: :bar} }

          it "ignores them" do
            expect(service_result).to be_success.with_data(kwargs: {})
          end
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
      let(:service) { described_class.new(method_name: :result, organizer: organizer_service_instance) }
      let(:inspect_values) { {name: "Service::RunMethod(:result)"} }

      it "returns inspect values" do
        expect(service.inspect_values).to eq(inspect_values)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
