# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Reassignment, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:caller) { described_class.new(reassignemnt) }
  let(:reassignemnt) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment.new("foo") }

  let(:direction) { :output }
  let(:method) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(reassignemnt, direction: direction) }

  let(:service_class) { Class.new }
  let(:container) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service.cast(service_class) }

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
      let(:exception_message) do
        <<~TEXT
          Method caller failed to calculate reassignment for `#{method.name}`.

          Method callers can calculate only `in` methods, while reassignments are always `out` methods.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::CallerCanNotCalculateReassignment`" do
        expect { caller.calculate_value(method) }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::CallerCanNotCalculateReassignment)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::CallerCanNotCalculateReassignment) { caller.calculate_value(method) } }
          .to delegate_to(ConvenientService, :raise)
      end
    end

    describe "#validate_as_input_for_container!" do
      let(:direction) { :input }

      let(:exception_message) do
        <<~TEXT
          Reassignments are not allowed for `in` methods.
        TEXT
      end

      it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::InputMethodReassignment`" do
        expect { caller.validate_as_input_for_container!(container, method: method) }
          .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::InputMethodReassignment)
          .with_message(exception_message)
      end

      specify do
        expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::InputMethodReassignment) { caller.validate_as_input_for_container!(container, method: method) } }
          .to delegate_to(ConvenientService, :raise)
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

    describe "#define_output_in_container!" do
      let(:index) { 0 }

      before do
        ##
        # NOTE: Warmup.
        #
        caller.define_output_in_container!(container, index: index, method: method)
      end

      specify do
        expect { caller.define_output_in_container!(container, index: index, method: method) }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::DefineMethodInContainer, :call)
          .with_arguments(method: method, container: container, index: index)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
