# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Group, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:sub_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(step) }
  let(:expression) { described_class.new(sub_expression) }

  let(:container) do
    Class.new do
      include ConvenientService::Standard::Config

      step :foo

      def foo
        success
      end
    end
  end

  let(:organizer) { container.new }

  let(:step) { organizer.steps.first }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      it "is overridden" do
        expect { described_class.new(sub_expression) }.not_to raise_error
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

    describe "#expression" do
      it "returns `sub_expression` passed to constructor" do
        expect(expression.expression).to eq(sub_expression)
      end
    end

    describe "#result" do
      specify do
        expect { expression.result }
          .to delegate_to(sub_expression, :result)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#organizer" do
      specify do
        expect { expression.organizer }
          .to delegate_to(sub_expression, :organizer)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#success?" do
      specify do
        expect { expression.success? }
          .to delegate_to(sub_expression, :success?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#failure?" do
      specify do
        expect { expression.failure? }
          .to delegate_to(sub_expression, :failure?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#error?" do
      specify do
        expect { expression.error? }
          .to delegate_to(sub_expression, :error?)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#each_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(sub_expression, :each_step)
          .with_arguments(&block)
      end

      it "returns `expression`" do
        expect(expression.each_step(&block)).to eq(expression)
      end
    end

    describe "#each_evaluated_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { expression.each_evaluated_step(&block) }
          .to delegate_to(sub_expression, :each_evaluated_step)
          .with_arguments(&block)
      end

      it "returns `expression`" do
        expect(expression.each_evaluated_step(&block)).to eq(expression)
      end
    end

    describe "#with_organizer" do
      specify do
        expect { expression.with_organizer(organizer) }
          .to delegate_to(expression, :copy)
          .with_arguments(overrides: {args: {0 => sub_expression.with_organizer(organizer)}})
          .and_return_its_value
      end
    end

    describe "#inspect" do
      it "returns inspect representation" do
        expect(expression.inspect).to eq("(#{sub_expression.inspect})")
      end
    end

    describe "#group?" do
      it "returns `true`" do
        expect(expression.group?).to be(true)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:expression) { described_class.new(sub_expression) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(expression == other).to be_nil
          end
        end

        context "when `other` has different `sub_expression`" do
          let(:other) { described_class.new(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(step.copy(overrides: {kwargs: {index: -1}}))) }

          it "returns `false`" do
            expect(expression == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(sub_expression) }

          it "returns `true`" do
            expect(expression == other).to be(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(sub_expression) }

      describe "#to_arguments" do
        it "returns arguments representation of `expression`" do
          expect(expression.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
