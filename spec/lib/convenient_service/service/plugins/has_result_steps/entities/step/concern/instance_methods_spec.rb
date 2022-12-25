# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern::InstanceMethods do
  ##
  # TODO: Context with `service`.
  #
  let(:step_service_klass) do
    Class.new do
      include ConvenientService::Service::Plugins::HasResult::Concern

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      class self::Result
        include ConvenientService::Core

        concerns do
          use ConvenientService::Common::Plugins::HasInternals::Concern
          use ConvenientService::Common::Plugins::HasConstructor::Concern
          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
        end

        middlewares :initialize do
          use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
        end

        class self::Internals
          include ConvenientService::Core

          concerns do
            use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end
        end
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

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
      include ConvenientService::Service::Plugins::HasResult::Concern

      # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      class self::Result
        include ConvenientService::Core

        concerns do
          use ConvenientService::Common::Plugins::HasInternals::Concern
          use ConvenientService::Common::Plugins::HasConstructor::Concern
          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern
        end

        middlewares :initialize do
          use ConvenientService::Common::Plugins::NormalizesEnv::Middleware

          use ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Middleware
        end

        class self::Internals
          include ConvenientService::Core

          concerns do
            use ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins::HasCache::Concern
          end
        end
      end
      # rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock

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
  let(:kwargs) { {in: inputs, out: outputs, index: 0, container: container, organizer: organizer} }

  let(:step_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:step_instance) { step_class.new(*args, **kwargs) }
  let(:step) { step_instance }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "delegators" do
  #   include Shoulda::Matchers::Independent
  #
  #   subject { step }
  #
  #   it { is_expected.to delegate_method(:success?).to(:result) }
  #   it { is_expected.to delegate_method(:failure?).to(:result) }
  #   it { is_expected.to delegate_method(:error?).to(:result) }
  #   it { is_expected.to delegate_method(:not_success?).to(:result) }
  #   it { is_expected.to delegate_method(:not_failure?).to(:result) }
  #   it { is_expected.to delegate_method(:not_error?).to(:result) }
  #
  #   it { is_expected.to delegate_method(:service).to(:params) }
  #   it { is_expected.to delegate_method(:outputs).to(:params) }
  #   it { is_expected.to delegate_method(:index).to(:params) }
  #   it { is_expected.to delegate_method(:container).to(:params) }
  #   it { is_expected.to delegate_method(:organizer).to(:params) }
  # end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    example_group "comparison" do
      describe "#==" do
        context "when steps have different classes" do
          let(:other) { "string" }

          it "returns `nil`" do
            expect(step == other).to eq(nil)
          end
        end

        context "when steps have different services" do
          let(:other) { step_class.new(Class.new, **kwargs) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when steps have different inputs" do
          let(:other) { step_class.new(*args, **kwargs.merge(in: [])) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when steps have different outputs" do
          let(:other) { step_class.new(*args, **kwargs.merge(out: [])) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when steps have different indices" do
          let(:other) { step_class.new(*args, **kwargs.merge(index: 1)) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when steps have different containers" do
          let(:other) { step_class.new(*args, **kwargs.merge(container: Class.new)) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when steps have different organizers" do
          let(:other) { step_class.new(*args, **kwargs.merge(organizer: nil)) }

          it "returns `false`" do
            expect(step == other).to eq(false)
          end
        end

        context "when steps have same attributes" do
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

    describe "#completed?" do
      context "when `step` is NOT completed" do
        it "returns `false`" do
          expect(step.completed?).to eq(false)
        end
      end

      context "when `step` is completed" do
        it "returns `true`" do
          step.result

          expect(step.completed?).to eq(true)
        end
      end
    end

    describe "#inputs" do
      specify { expect { step.inputs }.to delegate_to(step.params, :inputs) }

      it "returns copies of inputs with organizer set" do
        expect(step.inputs.map(&:organizer)).to eq([organizer])
      end
    end

    describe "#validate!" do
      specify {
        expect { step.validate! }
          .to delegate_to(step.inputs.first, :validate_as_input_for_container!)
          .with_arguments(step.container)
      }

      specify {
        expect { step.validate! }
          .to delegate_to(step.outputs.first, :validate_as_output_for_container!)
          .with_arguments(step.container)
      }

      it "returns `true`" do
        expect(step.validate!).to eq(true)
      end
    end

    describe "#define!" do
      let(:index) { 0 }

      specify {
        expect { step.define! }
          .to delegate_to(step.outputs.first, :define_output_in_container!)
          .with_arguments(step.container, index: index)
      }

      it "returns `true`" do
        expect(step.define!).to eq(true)
      end
    end

    describe "#input_values" do
      context "when `organizer` is NOT set" do
        let(:organizer) { nil }

        let(:message) do
          <<~TEXT
            Step `#{step.service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResultSteps::Errors::StepHasNoOrganizer`" do
          expect { step.input_values }
            .to raise_error(ConvenientService::Service::Plugins::HasResultSteps::Errors::StepHasNoOrganizer)
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

    describe "#result" do
      context "when `organizer` is NOT set" do
        let(:organizer) { nil }

        let(:message) do
          <<~TEXT
            Step `#{step.service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::HasResultSteps::Errors::StepHasNoOrganizer`" do
          expect { step.result }
            .to raise_error(ConvenientService::Service::Plugins::HasResultSteps::Errors::StepHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify {
          expect { step.result }
            .to delegate_to(service, :result)
            .with_arguments(**step.input_values)
            .and_return_its_value
        }

        it "marks `step` as complete" do
          expect { step.result }.to change(step, :completed?).from(false).to(true)
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
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
