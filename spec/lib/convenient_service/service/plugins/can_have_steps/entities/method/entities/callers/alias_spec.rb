# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Alias do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(alias_name) }
  let(:alias_name) { :bar }
  let(:direction) { :input }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base) }
  end

  example_group "instance methods" do
    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(return_value) do |return_value|
          define_method(:bar) { return_value }
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:return_value) { "return value" }

    let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method
        .cast({foo: alias_name}, direction: direction)
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

        let(:exception_message) do
          <<~TEXT
            Alias `in` method `#{method.name}` is NOT defined in `#{container.klass}`.

            Did you forget to define it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::AliasInputMethodIsNotDefinedInContainer`" do
          expect { caller.validate_as_input_for_container!(container, method: method) }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::AliasInputMethodIsNotDefinedInContainer)
            .with_message(exception_message)
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
        let(:exception_message) do
          <<~TEXT
            Alias `out` method `#{method.name}` is already defined in `#{container.klass}`.

            Did you forget to remove it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::AliasOutputMethodIsDefinedInContainer`" do
          expect { caller.validate_as_output_for_container!(container, method: method) }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::AliasOutputMethodIsDefinedInContainer)
            .with_message(exception_message)
        end
      end
    end

    describe "#define_output_in_container!" do
      let(:direction) { :output }
      let(:index) { 0 }

      specify {
        expect { caller.define_output_in_container!(container, index: index, method: method) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::DefineMethodInContainer, :call)
          .with_arguments(container: container, index: index, method: method)
          .and_return_its_value
      }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
