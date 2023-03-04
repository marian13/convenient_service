# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Proc do
  let(:caller) { described_class.new(proc) }
  let(:proc) { -> { :bar } }
  let(:direction) { :input }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base) }
  end

  example_group "instance methods" do
    let(:service_class) { Class.new }
    let(:service_instance) { service_class.new }

    let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method
        .cast({foo: proc}, direction: direction)
        .copy(overrides: {kwargs: {organizer: organizer}})
    end

    describe "#calculate_value" do
      it "delegates to `organizer.instance_exec(&proc)`" do
        ##
        # TODO: How to write something like: `allow(organizer).to receive(:instance_exec).with(proc).and_call_original`?
        #
        allow(organizer).to receive(:instance_exec).and_call_original

        caller.calculate_value(method)

        expect(organizer).to have_received(:instance_exec)
      end

      it "returns value of `organizer.instance_exec(&proc)`" do
        expect(caller.calculate_value(method)).to eq(organizer.instance_exec(&proc))
      end
    end

    describe "#validate_as_input_for_container!" do
      let(:direction) { :input }

      it "returns `true`" do
        expect(caller.validate_as_input_for_container!(container, method: method)).to eq(true)
      end
    end

    describe "#validate_as_output_for_container!" do
      let(:direction) { :output }

      let(:error_message) do
        <<~TEXT
          Procs are not allowed for `out` methods.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Errors::OutputMethodProc`" do
        expect { caller.validate_as_output_for_container!(container, method: method) }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Errors::OutputMethodProc)
          .with_message(error_message)
      end
    end

    describe "#define_output_in_container!" do
      let(:direction) { :output }
      let(:index) { 0 }

      it "returns `true`" do
        expect(caller.define_output_in_container!(container, index: index, method: method)).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
