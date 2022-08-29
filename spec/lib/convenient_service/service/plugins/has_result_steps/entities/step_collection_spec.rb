# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Entities::StepCollection do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(::Enumerable) }
  end

  example_group "instance methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:step_collection) { described_class.new }
    let(:step) { ConvenientService::Service::Plugins::HasResultSteps::Entities::Step.new(Class.new, in: :foo, out: :bar, container: Class.new) }

    example_group "comparison" do
      describe "#==" do
        context "when `other' has different class" do
          let(:other) { 42 }

          it "returns `false'" do
            expect(step_collection == other).to be_nil
          end
        end

        context "when `other' has different `steps'" do
          let(:other) { described_class.new.tap { |collection| collection << step } }

          it "returns `false'" do
            expect(step_collection == other).to eq(false)
          end
        end

        context "when `other' has same attributes" do
          let(:other) { described_class.new }

          it "returns `true'" do
            expect(step_collection == other).to eq(true)
          end
        end
      end
    end

    describe "#each" do
      let(:block) { proc { |step| } }

      ##
      # TODO: `with_block'.
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

      it "adds `step' copy with index to `steps'" do
        step_collection << step_without_index

        expect(step_collection.steps).to eq([step_with_index])
      end

      it "increments index for next steps" do
        3.times { step_collection << step_without_index }

        expect(step_collection.steps.map(&:index)).to eq([0, 1, 2])
      end

      it "returns `steps'" do
        expect(step_collection << step_without_index).to eq([step_with_index])
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
