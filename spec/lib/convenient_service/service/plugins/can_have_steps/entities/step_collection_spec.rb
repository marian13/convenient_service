# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::StepCollection do
  let(:step_collection) { described_class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(::Enumerable) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `steps` are NOT passed" do
        let(:step_collection) { described_class.new }

        it "sets steps to empty array" do
          expect(step_collection.steps).to eq([])
        end
      end
    end
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:step) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step.new(Class.new, in: :foo, out: :bar, container: Class.new) }

    describe "#commit!" do
      let(:step_collection) { described_class.new(steps: steps) }
      let(:steps) { [step] }

      context "when step collection is NOT committed" do
        it "returns `true`" do
          expect(step_collection.commit!).to eq(true)
        end

        it "freezes step collection `steps`" do
          expect { step_collection.commit! }.to delegate_to(steps, :freeze)
        end

        specify do
          expect { step_collection.commit! }.to delegate_to(steps.first, :define!)
        end

        context "when step collection has multiple steps" do
          let(:steps) { [step] }
          let(:other_step) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step.new(Class.new, in: :baz, out: :qux, container: Class.new) }

          it "returns `true`" do
            expect(step_collection.commit!).to eq(true)
          end

          it "freezes step collection `steps`" do
            expect { step_collection.commit! }.to delegate_to(steps, :freeze)
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
      let(:step_collection) { described_class.new(steps: steps) }
      let(:steps) { [step] }

      context "when `steps` are NOT frozen" do
        it "returns `false`" do
          expect(step_collection.committed?).to eq(false)
        end
      end

      context "when `steps` are frozen" do
        before do
          steps.freeze
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
          step_collection << step
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

      ##
      # TODO: `with_block`.
      #
      # - https://github.com/rspec/rspec-mocks/issues/1182
      # - https://stackoverflow.com/questions/27244034/test-if-a-block-is-passed-with-rspec-mocks
      #
      specify {
        expect { step_collection.each(&block) }
          .to delegate_to(step_collection, :steps)
          .and_return_its_value
      }
    end

    describe "#<<" do
      let(:step_without_index) { step }
      let(:step_with_index) { step.copy(overrides: {kwargs: {index: 0}}) }

      it "adds `step` copy with index to `steps`" do
        step_collection << step_without_index

        expect(step_collection.steps).to eq([step_with_index])
      end

      it "increments index for next steps" do
        3.times { step_collection << step_without_index }

        expect(step_collection.steps.map(&:index)).to eq([0, 1, 2])
      end

      it "returns `steps`" do
        expect(step_collection << step_without_index).to eq([step_with_index])
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

        context "when `other` has different `steps`" do
          let(:other) { described_class.new.tap { |collection| collection << step } }

          it "returns `false`" do
            expect(step_collection == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new }

          it "returns `true`" do
            expect(step_collection == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
