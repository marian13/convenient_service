# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Usual do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(:foo) }
  let(:direction) { :input }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Base) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(return_value) do |return_value|
          define_method(:foo) { return_value }
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:return_value) { "return value" }

    let(:container) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::HasResultSteps::Entities::Method
        .cast(:foo, direction: direction)
        .copy(overrides: {kwargs: {organizer: organizer}})
    end

    describe "#calculate_value" do
      it "delegates to `organizer.__send__`" do
        allow(organizer).to receive(:__send__).with(method.name.to_s).and_call_original

        caller.calculate_value(method)

        expect(organizer).to have_received(:__send__)
      end

      it "returns value of `organizer.__send__`" do
        expect(caller.calculate_value(method)).to eq(return_value)
      end
    end

    describe "#validate_as_input_for_container!" do
      let(:direction) { :input }

      context "when container does NOT have defined method" do
        let(:service_class) { Class.new }

        let(:error_message) do
          <<~TEXT
            `in` method `#{method.name}` is NOT defined in `#{container.klass}`.

            Did you forget to define it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::InputMethodIsNotDefinedInContainer`" do
          expect { caller.validate_as_input_for_container!(container, method: method) }
            .to raise_error(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::InputMethodIsNotDefinedInContainer)
            .with_message(error_message)
        end
      end

      context "when container has defined method" do
        it "returns `true`" do
          expect(caller.validate_as_input_for_container!(container, method: method)).to eq(true)
        end
      end
    end

    describe "#validate_as_output_for_container!" do
      let(:direction) { :output }

      context "when container does NOT have defined method" do
        let(:service_class) { Class.new }

        it "returns `true`" do
          expect(caller.validate_as_output_for_container!(container, method: method)).to eq(true)
        end
      end

      context "when container has defined method" do
        let(:error_message) do
          <<~TEXT
            `out` method `#{method.name}` is already defined in `#{container.klass}`.

            Did you forget to remove it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::OutputMethodIsDefinedInContainer`" do
          expect { caller.validate_as_output_for_container!(container, method: method) }
            .to raise_error(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::OutputMethodIsDefinedInContainer)
            .with_message(error_message)
        end
      end
    end

    describe "#define_output_in_container!" do
      let(:direction) { :output }
      let(:index) { 0 }

      specify {
        expect { caller.define_output_in_container!(container, index: index, method: method) }
          .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::DefineMethodInContainer, :call)
          .with_arguments(container: container, index: index, method: method)
          .and_return_its_value
      }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
