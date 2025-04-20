# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_collection) { described_class.new(container: container) }

  let(:container) do
    Class.new do
      include ConvenientService::Standard::Config
    end
  end

  let(:organizer) { container.new }

  let(:step) { container.step_class.new(*args, **kwargs) }

  let(:args) { [Class.new] }
  let(:kwargs) { {in: :foo, out: :bar, container: container} }

  let(:expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(step) }
  let(:steps) { [step] }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(::Enumerable) }
    it { is_expected.to include_module(ConvenientService::Support::Copyable) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `expression` is NOT passed" do
        let(:step_collection) { described_class.new(container: container) }

        it "sets `expression` to empty expression" do
          expect(step_collection.expression).to eq(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Empty.new)
        end
      end

      context "when `steps` are NOT passed" do
        let(:step_collection) { described_class.new(container: container) }

        it "sets `steps` to empty array" do
          expect(step_collection.steps).to eq([])
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#container" do
      it "returns `container` passed to constructor" do
        expect(step_collection.container).to eq(container)
      end
    end

    describe "#expression" do
      context "when `step collection` has NO `expression`" do
        let(:step_collection) { described_class.new(container: container) }

        it "returns empty expression" do
          expect(step_collection.expression).to eq(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Empty.new)
        end
      end

      context "when `step collection` has `expression`" do
        let(:step_collection) { described_class.new(container: container, expression: expression) }

        it "returns that `expression`" do
          expect(step_collection.expression).to eq(expression)
        end
      end
    end

    describe "#steps" do
      context "when `step collection` has NO `steps`" do
        let(:step_collection) { described_class.new(container: container) }

        it "returns empty array" do
          expect(step_collection.steps).to eq([])
        end
      end

      context "when `step collection` has `steps`" do
        let(:step_collection) { described_class.new(container: container, steps: steps) }

        it "returns array with those `steps`" do
          expect(step_collection.steps).to eq(steps)
        end
      end
    end

    describe "#size" do
      specify do
        expect { step_collection.size }
          .to delegate_to(step_collection.steps, :size)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#create" do
      let(:step_without_index) { step }
      let(:step_with_index) { step.copy(overrides: {kwargs: {index: 0}}) }

      it "returns `step`" do
        expect(step_collection.create(*args, **kwargs)).to eq(step_with_index)
      end

      it "adds `step` to `steps`" do
        step_collection.create(*args, **kwargs)

        expect(step_collection.steps).to eq([step_with_index])
      end

      specify do
        expect { step_collection.create(*args, **kwargs) }
          .to delegate_to(container.step_class, :new)
          .with_arguments(*args, **kwargs.merge(container: container, index: 0))
      end

      context "when called twice" do
        let(:previous_step) { step_collection.create(*args, **kwargs) }
        let(:next_step) { step_collection.create(*args, **kwargs) }

        before do
          previous_step
        end

        it "increments index for next created `step`" do
          expect(next_step.index).to eq(1)
        end

        context "when called more than twice" do
          let(:other_previous_step) { step_collection.create(*args, **kwargs) }

          before do
            other_previous_step
          end

          it "increments index for next created `step`" do
            expect(next_step.index).to eq(2)
          end
        end
      end
    end

    describe "#with_organizer" do
      let(:step_collection) { described_class.new(container: container, expression: expression, steps: steps) }
      let(:expression_with_organizer) { expression.with_organizer(organizer) }

      specify do
        expect { step_collection.with_organizer(organizer) }
          .to delegate_to(step_collection, :copy)
          .with_arguments(overrides: {kwargs: {expression: expression_with_organizer, steps: expression_with_organizer.steps}})
          .and_return_its_value
      end

      context "when `step_collection` is NOT frozen" do
        it "returns NOT frozen `step_collection` with `organizer`" do
          expect(step_collection.with_organizer(organizer)).not_to be_frozen
        end

        it "returns `step_collection` with `organizer` with NOT frozen `expression`" do
          expect(step_collection.with_organizer(organizer).expression).not_to be_frozen
        end

        it "returns `step_collection` with `organizer` with NOT frozen `steps`" do
          expect(step_collection.with_organizer(organizer).steps).not_to be_frozen
        end
      end

      context "when `step_collection` is frozen" do
        before do
          step_collection.freeze
        end

        it "returns frozen `step_collection` with `organizer`" do
          expect(step_collection.with_organizer(organizer)).to be_frozen
        end

        it "returns `step_collection` with `organizer` with frozen `expression`" do
          expect(step_collection.with_organizer(organizer).expression).to be_frozen
        end

        it "returns `step_collection` with `organizer` with frozen `steps`" do
          expect(step_collection.with_organizer(organizer).steps).to be_frozen
        end
      end
    end

    describe "#commit!" do
      let(:step_collection) { described_class.new(container: container, expression: expression, steps: steps) }

      context "when step collection is NOT committed" do
        it "returns `true`" do
          expect(step_collection.commit!).to eq(true)
        end

        ##
        # NOTE: Stubs on `freeze` generate warnings.
        #
        it "freezes step collection" do
          expect { step_collection.commit! }.to change(step_collection, :frozen?).from(false).to(true)
        end

        ##
        # NOTE: Stubs on `freeze` generate warnings.
        #
        it "freezes step collection `expression`" do
          expect { step_collection.commit! }.to change(expression, :frozen?).from(false).to(true)
        end

        ##
        # NOTE: Stubs on `freeze` generate warnings.
        #
        it "freezes step collection `steps`" do
          expect { step_collection.commit! }.to change(steps, :frozen?).from(false).to(true)
        end

        specify do
          expect { step_collection.commit! }.to delegate_to(steps.first, :define!)
        end

        context "when step collection has multiple steps" do
          let(:expression) do
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Or.new(
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(step),
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(other_step)
            )
          end

          let(:steps) { [step, other_step] }
          let(:other_step) { container.step_class.new(*args, **kwargs) }

          it "returns `true`" do
            expect(step_collection.commit!).to eq(true)
          end

          specify do
            expect { step_collection.commit! }.to delegate_to(steps.first, :define!)
          end

          specify do
            expect { step_collection.commit! }.to delegate_to(steps.last, :define!)
          end
        end
      end

      context "when step collection is committed" do
        before do
          step_collection.commit!
        end

        it "returns `false`" do
          expect(step_collection.commit!).to eq(false)
        end
      end
    end

    describe "#committed?" do
      let(:step_collection) { described_class.new(container: container, expression: expression, steps: steps) }

      context "when `step_collection` is NOT frozen" do
        it "returns `false`" do
          expect(step_collection.committed?).to eq(false)
        end
      end

      context "when `step_collection` is frozen" do
        before do
          step_collection.freeze
        end

        it "returns `true`" do
          expect(step_collection.committed?).to eq(true)
        end
      end
    end

    describe "#[]" do
      let(:index) { 0 }

      context "when step collection has NO step by index" do
        it "returns `nil`" do
          expect(step_collection[index]).to be_nil
        end

        specify do
          expect { step_collection[index] }
            .to delegate_to(step_collection.steps, :[])
            .with_arguments(index)
            .and_return_its_value
        end
      end

      context "when step collection has step by index" do
        before do
          step_collection.create(*args, **kwargs)
        end

        it "returns step by index" do
          expect(step_collection[index]).to eq(step_collection.steps[index])
        end

        specify do
          expect { step_collection[index] }
            .to delegate_to(step_collection.steps, :[])
            .with_arguments(index)
            .and_return_its_value
        end
      end
    end

    describe "#each" do
      let(:block) { proc { |step| } }

      specify do
        expect { step_collection.each(&block) }
          .to delegate_to(step_collection.expression, :each_step)
          .with_arguments(&block)
          .and_return_its_value
      end
    end

    describe "#each_step" do
      let(:block) { proc { |step| } }

      specify do
        expect { step_collection.each_step(&block) }
          .to delegate_to(step_collection.expression, :each_step)
          .with_arguments(&block)
          .and_return_its_value
      end
    end

    describe "#each_evaluated_step" do
      let(:block) { proc { |step| } }

      specify do
        expect { step_collection.each_evaluated_step(&block) }
          .to delegate_to(step_collection.expression, :each_evaluated_step)
          .with_arguments(&block)
          .and_return_its_value
      end
    end

    describe "#inspect" do
      specify do
        expect { step_collection.inspect }
          .to delegate_to(step_collection.expression, :inspect)
          .without_arguments
          .and_return_its_value
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(step_collection == other).to be_nil
          end
        end

        context "when `other` has different `container`" do
          let(:other) { described_class.new(container: Class.new) }

          it "returns `false`" do
            expect(step_collection == other).to eq(false)
          end
        end

        context "when `other` has different `expression`" do
          let(:other) { described_class.new(container: container).tap { |collection| collection.expression = ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(step.copy(overrides: {kwargs: {index: -1}})) } }

          it "returns `false`" do
            expect(step_collection == other).to eq(false)
          end
        end

        context "when `other` has different `steps`" do
          let(:other) { described_class.new(container: container).tap { |collection| collection.create(*args, **kwargs) } }

          it "returns `false`" do
            expect(step_collection == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(container: container) }

          it "returns `true`" do
            expect(step_collection == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:step_collection) { described_class.new(container: container, expression: expression, steps: steps) }
      let(:arguments) { ConvenientService::Support::Arguments.new(container: container, expression: expression, steps: steps) }

      describe "#to_arguments" do
        it "returns arguments representation of `step collection`" do
          expect(step_collection.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
