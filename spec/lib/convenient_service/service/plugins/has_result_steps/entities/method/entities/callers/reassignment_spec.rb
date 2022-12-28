# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, Spec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Reassignment do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(reassignemnt) }
  let(:reassignemnt) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Values::Reassignment.new("foo") }

  let(:direction) { :output }
  let(:method) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Method.cast(reassignemnt, direction: direction) }

  let(:service_class) { Class.new }
  let(:container) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Service.cast(service_class) }

  example_group "instance methods" do
    describe "#reassignment?" do
      let(:name) { +"foo" }

      specify { expect { caller.reassignment?(name) }.to delegate_to(reassignemnt, :to_sym) }
      specify { expect { caller.reassignment?(name) }.to delegate_to(name, :to_sym) }

      context "when reassignemnt casted to symbol is NOT the same as name casted to symbol" do
        let(:name) { "bar" }

        it "returns `false`" do
          expect(caller.reassignment?(name)).to eq(false)
        end
      end

      context "when reassignemnt casted to symbol is the same as name casted to symbol" do
        let(:name) { "foo" }

        it "returns `true`" do
          expect(caller.reassignment?(name)).to eq(true)
        end
      end
    end

    describe "#calculate_value" do
      let(:error_message) do
        <<~TEXT
          Method caller failed to calculate reassignment for `#{method.name}`.

          Method callers can calculate only `in` methods, while reassignments are always `out` methods.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Reassignment::Errors::CallerCanNotCalculateReassignment`" do
        expect { caller.calculate_value(method) }
          .to raise_error(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Callers::Reassignment::Errors::CallerCanNotCalculateReassignment)
          .with_message(error_message)
      end
    end

    describe "#validate_as_input_for_container!" do
      let(:direction) { :input }

      it "returns `false`" do
        expect(caller.validate_as_input_for_container!(container, method: method)).to eq(false)
      end
    end

    describe "#validate_as_output_for_container!" do
      let(:direction) { :output }

      ##
      # TODO: Raise when container has two reassignments with same name.
      #
      it "returns `true`" do
        expect(caller.validate_as_output_for_container!(container, method: method)).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, Spec/MultipleMemoizedHelpers
