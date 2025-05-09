# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Usual, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(:foo) }
  let(:direction) { :input }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:service_class) do
      Class.new.tap do |klass|
        klass.class_exec(return_value) do |return_value|
          include ConvenientService::Core

          define_method(:foo) { return_value }
        end
      end
    end

    let(:service_instance) { service_class.new }
    let(:return_value) { "return value" }

    let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }
    let(:organizer) { service_instance }

    let(:method) do
      ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method
        .cast(:foo, direction: direction)
        .copy(overrides: {kwargs: {organizer: organizer}})
    end

    describe "#usual?" do
      it "returns `true`" do
        expect(caller.usual?).to eq(true)
      end
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

    describe "#define_output_in_container!" do
      let(:direction) { :output }
      let(:index) { 0 }

      specify do
        caller.define_output_in_container!(container, index: index, method: method)

        expect { caller.define_output_in_container!(container, index: index, method: method) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::DefineMethodInContainer, :call)
          .with_arguments(container: container, index: index, method: method)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
