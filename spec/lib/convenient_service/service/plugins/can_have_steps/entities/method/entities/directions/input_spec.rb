# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input do
  let(:direction) { described_class.new }
  let(:options) { {direction: :input} }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Base) }
  end

  example_group "instance methods" do
    let(:service_class) { Class.new }
    let(:service_instance) { service_class.new }

    let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method
        .cast(:foo, **options)
        .copy(overrides: {kwargs: {organizer: organizer}})
    end

    describe "#validate_as_input_for_container!" do
      let(:options) { {direction: :input} }

      it "returns `true`" do
        expect(direction.validate_as_input_for_container!(container, method: method)).to eq(true)
      end
    end

    describe "#validate_as_output_for_container!" do
      let(:options) { {direction: :output} }

      let(:exception_message) do
        <<~TEXT
          Method `#{method.name}` is NOT an `out` method.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod`" do
        expect { direction.validate_as_output_for_container!(container, method: method) }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod)
          .with_message(exception_message)
      end
    end

    describe "#define_output_in_container!" do
      let(:options) { {direction: :output} }
      let(:index) { 0 }

      let(:exception_message) do
        <<~TEXT
          Method `#{method.name}` is NOT an `out` method.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod`" do
        expect { direction.define_output_in_container!(container, index: index, method: method) }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodIsNotOutputMethod)
          .with_message(exception_message)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
