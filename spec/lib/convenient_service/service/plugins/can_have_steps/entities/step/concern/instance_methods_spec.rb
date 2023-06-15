# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Concern::InstanceMethods do
  let(:step_service_klass) do
    Class.new do
      include ConvenientService::Configs::Minimal

      def initialize(foo:)
        @foo = foo
      end

      def result
        success
      end
    end
  end

  let(:organizer_service_klass) do
    Class.new do
      include ConvenientService::Configs::Minimal

      def result
        success
      end

      def foo
        :organizer_foo
      end
    end
  end

  let(:service) { step_service_klass }
  let(:inputs) { [:foo] }
  let(:outputs) { [:bar] }
  let(:container) { organizer_service_klass }
  let(:organizer) { organizer_service_klass.new }

  let(:args) { [service] }
  let(:kwargs) { {in: inputs, out: outputs, index: index, container: container, organizer: organizer} }

  let(:step_class) { organizer_service_klass.step_class }

  let(:step_instance) { step_class.new(*args, **kwargs) }
  let(:step) { step_instance }

  let(:index) { 0 }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe "#success?" do
      specify do
        expect { step.success? }
          .to delegate_to(step.result, :success?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#failure?" do
      specify do
        expect { step.failure? }
          .to delegate_to(step.result, :failure?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#error?" do
      specify do
        expect { step.error? }
          .to delegate_to(step.result, :error?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#not_success?" do
      specify do
        expect { step.not_success? }
          .to delegate_to(step.result, :not_success?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#not_failure?" do
      specify do
        expect { step.not_failure? }
          .to delegate_to(step.result, :not_failure?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#not_error?" do
      specify do
        expect { step.not_error? }
          .to delegate_to(step.result, :not_error?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#data" do
      specify do
        expect { step.data }
          .to delegate_to(step.result, :data)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#message" do
      specify do
        expect { step.message }
          .to delegate_to(step.result, :message)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#code" do
      specify do
        expect { step.code }
          .to delegate_to(step.result, :code)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#unsafe_data" do
      specify do
        expect { step.unsafe_data }
          .to delegate_to(step.result, :unsafe_data)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#unsafe_message" do
      specify do
        expect { step.unsafe_message }
          .to delegate_to(step.result, :unsafe_message)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#unsafe_code" do
      specify do
        expect { step.unsafe_code }
          .to delegate_to(step.result, :unsafe_code)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#service" do
      specify do
        expect { step.service }
          .to delegate_to(step.params, :service)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#outputs" do
      specify do
        expect { step.outputs }
          .to delegate_to(step.params, :outputs)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#index" do
      specify do
        expect { step.index }
          .to delegate_to(step.params, :index)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#container" do
      specify do
        expect { step.container }
          .to delegate_to(step.params, :container)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#organizer" do
      specify do
        expect { step.organizer }
          .to delegate_to(step.params, :organizer)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#extra_kwargs" do
      specify do
        expect { step.extra_kwargs }
          .to delegate_to(step.params, :extra_kwargs)
          .without_arguments
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { "string" }

          it "returns `nil`" do
            expect(step == other).to eq(nil)
          end
        end

        context "when `other` has different service" do
          let(:other) { step_class.new(Class.new, **kwargs) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when `other` has different inputs" do
          let(:other) { step_class.new(*args, **kwargs.merge(in: [])) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when `other` has different outputs" do
          let(:other) { step_class.new(*args, **kwargs.merge(out: [])) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when `other` has different index" do
          let(:other) { step_class.new(*args, **kwargs.merge(index: 1)) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when `other` has different container" do
          let(:other) { step_class.new(*args, **kwargs.merge(container: Class.new)) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when `other` has different organizer" do
          let(:other) { step_class.new(*args, **kwargs.merge(organizer: nil)) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { step_class.new(*args, **kwargs) }

          it "returns `true`" do
            expect(step == other).to eq(true)
          end
        end
      end
    end

    describe "#has_organizer?" do
      context "when `organizer` is NOT set" do
        let(:organizer) { nil }

        it "returns `false`" do
          expect(step.has_organizer?).to eq(false)
        end
      end

      context "when `organizer` is set" do
        let(:organizer) { double }

        it "returns `true`" do
          expect(step.has_organizer?).to eq(true)
        end
      end
    end

    describe "#has_reassignment?" do
      let(:name) { :bar }

      context "when `step` has NO reassignemnt output" do
        let(:outputs) { [:bar] }

        it "returns `false`" do
          expect(step.has_reassignment?(name)).to eq(false)
        end
      end

      context "when `step` has reassignemnt output" do
        let(:outputs) { [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment.new(:bar)] }

        it "returns `true`" do
          expect(step.has_reassignment?(name)).to eq(true)
        end
      end
    end

    describe "#reassignment" do
      let(:name) { :bar }

      context "when `step` has NO reassignemnt output" do
        let(:outputs) { [:bar] }

        it "returns `nil`" do
          expect(step.reassignment(name)).to be_nil
        end
      end

      context "when `step` has reassignemnt output" do
        let(:reassignemnt) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment.new(:bar) }
        let(:outputs) { [reassignemnt] }

        it "returns that reassignemnt" do
          expect(step.reassignment(name)).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(reassignemnt, direction: :output))
        end
      end
    end

    describe "#inputs" do
      specify { expect { step.inputs }.to delegate_to(step.params, :inputs) }

      it "returns copies of inputs with organizer set" do
        expect(step.inputs.map(&:organizer)).to eq([organizer])
      end
    end

    describe "#trigger_callback" do
      specify do
        expect { step.trigger_callback }
          .to delegate_to(step.organizer, :step)
          .with_arguments(index)
      end
    end

    describe "#validate!" do
      specify do
        expect { step.validate! }
          .to delegate_to(step.inputs.first, :validate_as_input_for_container!)
          .with_arguments(step.container)
      end

      specify do
        expect { step.validate! }
          .to delegate_to(step.outputs.first, :validate_as_output_for_container!)
          .with_arguments(step.container)
      end

      it "returns `true`" do
        expect(step.validate!).to eq(true)
      end
    end

    describe "#define!" do
      specify do
        expect { step.define! }
          .to delegate_to(step.outputs.first, :define_output_in_container!)
          .with_arguments(step.container, index: index)
      end

      it "returns `true`" do
        expect(step.define!).to eq(true)
      end
    end

    describe "#input_values" do
      context "when `organizer` is NOT set" do
        let(:organizer) { nil }

        let(:message) do
          <<~TEXT
            Step `#{step.printable_service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer`" do
          expect { step.input_values }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        it "returns input values" do
          expect(step.input_values).to eq({foo: :organizer_foo})
        end

        specify { expect { step.input_values }.to delegate_to(step.inputs.first.key, :to_sym) }
      end
    end

    describe "#service_result" do
      context "when `organizer` is NOT set" do
        let(:organizer) { nil }

        let(:message) do
          <<~TEXT
            Step `#{step.printable_service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer`" do
          expect { step.service_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          expect { step.service_result }
            .to delegate_to(step.service.klass, :result)
            .with_arguments(**step.input_values)
            .and_return_its_value
        end
      end
    end

    describe "#result" do
      context "when `organizer` is NOT set" do
        let(:organizer) { nil }

        let(:message) do
          <<~TEXT
            Step `#{step.printable_service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer`" do
          expect { step.result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          expect { step.result }
            .to delegate_to(step.service_result, :copy)
            .with_arguments(overrides: {kwargs: {step: step, service: organizer}})
            .and_return_its_value
        end
      end
    end

    describe "#printable_service" do
      it "returns printable service as string" do
        expect(step.printable_service).to eq(step.service.klass.to_s)
      end
    end

    describe "#to_args" do
      let(:args_representation) { [step.service] }

      it "returns args representation of step" do
        expect(step.to_args).to eq(args_representation)
      end
    end

    describe "#to_kwargs" do
      let(:kwargs_representation) do
        {
          in: step.inputs,
          out: step.outputs,
          index: step.index,
          container: step.container,
          organizer: step.organizer
        }
      end

      it "returns kwargs representation of step" do
        expect(step.to_kwargs).to eq(kwargs_representation)
      end

      context "when constructor kwargs have extra values" do
        let(:kwargs) { {try: true, in: inputs, out: outputs, index: index, container: container, organizer: organizer} }

        let(:kwargs_representation) do
          {
            in: step.inputs,
            out: step.outputs,
            index: step.index,
            container: step.container,
            organizer: step.organizer,
            try: true
          }
        end

        it "includes them into kwargs representation of step" do
          expect(step.to_kwargs).to eq(kwargs_representation)
        end

        context "when constructor kwargs extra value has same key as value from kwargs representation" do
          let(:step_instance) { step_class.new(*args, **kwargs.merge(in: [:bar])) }
          let(:value) { [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:bar, direction: :input).copy(overrides: {kwargs: {organizer: organizer}})] }

          it "takes value from kwargs representation" do
            expect(step.to_kwargs[:in]).to eq(value)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
