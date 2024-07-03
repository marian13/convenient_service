# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:expression) { described_class.new(step) }

  let(:container) do
    Class.new do
      include ConvenientService::Service::Configs::Essential
      include ConvenientService::Service::Configs::Inspect
      step :foo

      def foo
        success
      end
    end
  end

  let(:organizer) { container.new }

  let(:step) { organizer.steps.first }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      it "is overridden" do
        expect { described_class.new(step) }.not_to raise_error
      end
    end
  end

  example_group "instance methods" do
    describe "#steps" do
      it "returns `steps` received from `each_step`" do
        expect(expression.steps).to eq([step])
      end

      specify do
        expect { expression.steps }.to delegate_to(expression, :each_step)
      end
    end

    describe "#step" do
      it "returns `step` passed to constructor" do
        expect(expression.step).to eq(step)
      end
    end

    describe "#result" do
      specify do
        expect { expression.result }
          .to delegate_to(expression.step, :result)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#success?" do
      specify do
        expect { expression.success? }
          .to delegate_to(step.result.status, :unsafe_success?)
          .without_arguments
          .and_return_its_value
      end

      specify do
        expect { expression.success? }
          .to delegate_to(expression, :result)
          .without_arguments
      end
    end

    describe "#failure?" do
      specify do
        expect { expression.failure? }
          .to delegate_to(step.result.status, :unsafe_failure?)
          .without_arguments
          .and_return_its_value
      end

      specify do
        expect { expression.failure? }
          .to delegate_to(expression, :result)
          .without_arguments
      end
    end

    describe "#error?" do
      specify do
        expect { expression.error? }
          .to delegate_to(step.result.status, :unsafe_error?)
          .without_arguments
          .and_return_its_value
      end

      specify do
        expect { expression.error? }
          .to delegate_to(expression, :result)
          .without_arguments
      end
    end

    describe "#each_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { |block| expression.each_step(&block) }.to yield_with_args(step)
      end

      it "returns `expression`" do
        expect(expression.each_step(&block)).to eq(expression)
      end
    end

    describe "#each_evaluated_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { expression.each_evaluated_step(&block) }
          .to delegate_to(expression, :result)
          .without_arguments
      end

      specify do
        expect { |block| expression.each_evaluated_step(&block) }.to yield_with_args(step)
      end

      it "calls `result` before `yield`" do
        expect { ignoring_exception(ArgumentError) { expression.each_evaluated_step { raise ArgumentError } } }
          .to delegate_to(expression, :result)
          .without_arguments
      end

      it "returns `expression`" do
        expect(expression.each_evaluated_step(&block)).to eq(expression)
      end
    end

    describe "#with_organizer" do
      specify do
        expect { expression.with_organizer(organizer) }
          .to delegate_to(expression, :copy)
          .with_arguments(overrides: {args: {0 => step.with_organizer(organizer)}})
          .and_return_its_value
      end
    end

    describe "#inspect" do
      it "returns inspect representation" do
        expect(expression.inspect).to eq("steps[#{step.index}]")
      end
    end

    describe "#scalar?" do
      it "returns `true`" do
        expect(expression.scalar?).to eq(true)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:expression) { described_class.new(step) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(expression == other).to be_nil
          end
        end

        context "when `other` has different `step`" do
          let(:other) { described_class.new(step.copy(overrides: {kwargs: {index: -1}})) }

          it "returns `false`" do
            expect(expression == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(step) }

          it "returns `true`" do
            expect(expression == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(step) }

      describe "#to_arguments" do
        it "returns arguments representation of `expression`" do
          expect(expression.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
