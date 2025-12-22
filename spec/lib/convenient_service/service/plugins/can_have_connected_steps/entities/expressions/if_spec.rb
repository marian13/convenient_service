# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:condition_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
  let(:then_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step) }
  let(:expression) { described_class.new(condition_expression, then_expression) }

  let(:container) do
    Class.new do
      include ConvenientService::Standard::Config

      step :foo
      step :bar

      def foo
        success(data: {from: :foo})
      end

      def bar
        success(data: {from: :bar})
      end
    end
  end

  let(:organizer) { container.new }

  let(:first_step) { organizer.steps[0] }
  let(:second_step) { organizer.steps[1] }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      it "is overridden" do
        expect { described_class.new(condition_expression, then_expression) }.not_to raise_error
      end
    end
  end

  example_group "instance methods" do
    describe "#steps" do
      it "returns `steps` received from `each_step`" do
        expect(expression.steps).to eq(condition_expression.steps + then_expression.steps)
      end

      specify do
        expect { expression.steps }.to delegate_to(condition_expression, :each_step)
      end

      specify do
        expect { expression.steps }.to delegate_to(then_expression, :each_step)
      end
    end

    describe "#condition_expression" do
      it "returns `condition_expression` passed to constructor" do
        expect(expression.condition_expression).to eq(condition_expression)
      end
    end

    describe "#then_expression" do
      it "returns `then_expression` passed to constructor" do
        expect(expression.then_expression).to eq(then_expression)
      end
    end

    describe "#result" do
      context "when `condition_expression` is NOT `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.result }
            .to delegate_to(condition_expression, :success?)
            .without_arguments
        end

        specify do
          expect { expression.result }
            .to delegate_to(condition_expression, :result)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `then_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(then_expression, :result)
        end
      end

      context "when `condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.result }
            .to delegate_to(condition_expression, :success?)
            .without_arguments
        end

        specify do
          ##
          # NOTE: Ensures that `condition_expression` is evaluated.
          #
          expect { expression.result }
            .to delegate_to(condition_expression, :result)
            .without_arguments
        end

        specify do
          expect { expression.result }
            .to delegate_to(then_expression, :result)
            .without_arguments
            .and_return_its_value
        end
      end
    end

    describe "#organizer" do
      specify do
        expect { expression.organizer }
          .to delegate_to(condition_expression, :organizer)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#success?" do
      context "when `condition_expression` is NOT `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.success? }
            .to delegate_to(condition_expression, :success?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `then_expression` is NOT evaluated.
          # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
          #
          expect { expression.success? }.not_to delegate_to(then_expression, :result)
        end
      end

      context "when `condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.success? }
            .to delegate_to(condition_expression, :success?)
            .without_arguments
        end

        specify do
          expect { expression.success? }
            .to delegate_to(then_expression, :success?)
            .without_arguments
            .and_return_its_value
        end
      end
    end

    describe "#failure?" do
      context "when `condition_expression` is NOT `success`" do
        context "when `condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end
            end
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(condition_expression, :failure?)
                .without_arguments
                .and_return { true }
          end

          specify do
            ##
            # NOTE: Ensures that `then_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.failure? }.not_to delegate_to(then_expression, :result)
          end
        end

        context "when `condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar

              def foo
                error(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end
            end
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(condition_expression, :failure?)
              .without_arguments
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(condition_expression, :error?)
                .without_arguments
                .and_return { false }
          end

          specify do
            ##
            # NOTE: Ensures that `then_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.failure? }.not_to delegate_to(then_expression, :result)
          end
        end
      end

      context "when `condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.failure? }
            .to delegate_to(condition_expression, :failure?)
            .without_arguments
        end

        specify do
          expect { expression.failure? }
            .to delegate_to(condition_expression, :error?)
            .without_arguments
        end

        specify do
          expect { expression.failure? }
            .to delegate_to(then_expression, :failure?)
            .without_arguments
            .and_return_its_value
        end
      end
    end

    describe "#error?" do
      context "when `condition_expression` is NOT `success`" do
        context "when `condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end
            end
          end

          specify do
            expect { expression.error? }
              .to delegate_to(condition_expression, :failure?)
                .without_arguments
                .and_return { false }
          end

          specify do
            expect { expression.error? }.not_to delegate_to(condition_expression, :error?)
          end

          specify do
            ##
            # NOTE: Ensures that `then_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.error? }.not_to delegate_to(then_expression, :result)
          end
        end

        context "when `condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar

              def foo
                error(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end
            end
          end

          specify do
            expect { expression.error? }
              .to delegate_to(condition_expression, :failure?)
              .without_arguments
          end

          specify do
            expect { expression.error? }
              .to delegate_to(condition_expression, :error?)
                .without_arguments
                .and_return { true }
          end

          specify do
            ##
            # NOTE: Ensures that `then_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.error? }.not_to delegate_to(then_expression, :result)
          end
        end
      end

      context "when `condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.error? }
            .to delegate_to(condition_expression, :failure?)
            .without_arguments
        end

        specify do
          expect { expression.error? }
            .to delegate_to(condition_expression, :error?)
            .without_arguments
        end

        specify do
          expect { expression.error? }
            .to delegate_to(then_expression, :error?)
            .without_arguments
            .and_return_its_value
        end
      end
    end

    describe "#each_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(condition_expression, :each_step)
          .with_arguments(&block)
      end

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(then_expression, :each_step)
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
          .to delegate_to(condition_expression, :each_evaluated_step)
          .with_arguments(&block)
      end

      context "when `condition_expression` is NOT `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              error(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(then_expression, :each_evaluated_step)
        end
      end

      context "when `condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end
          end
        end

        specify do
          expect { expression.each_evaluated_step(&block) }
            .to delegate_to(then_expression, :each_evaluated_step)
            .with_arguments(&block)
        end
      end

      it "returns `expression`" do
        expect(expression.each_evaluated_step(&block)).to eq(expression)
      end
    end

    describe "#with_organizer" do
      specify do
        expect { expression.with_organizer(organizer) }
          .to delegate_to(expression, :copy)
          .with_arguments(overrides: {args: {0 => condition_expression.with_organizer(organizer), 1 => then_expression.with_organizer(organizer)}})
          .and_return_its_value
      end
    end

    describe "#inspect" do
      it "returns inspect representation" do
        expect(expression.inspect).to eq("if #{condition_expression.inspect} then #{then_expression.inspect} end")
      end
    end

    describe "#if?" do
      it "returns `true`" do
        expect(expression.if?).to be(true)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:expression) { described_class.new(condition_expression, then_expression) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(expression == other).to be_nil
          end
        end

        context "when `other` has different `condition_expression`" do
          let(:other) { described_class.new(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step.copy(overrides: {kwargs: {index: -1}})), then_expression) }

          it "returns `false`" do
            expect(expression == other).to be(false)
          end
        end

        context "when `other` has different `then_expression`" do
          let(:other) { described_class.new(condition_expression, ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step.copy(overrides: {kwargs: {index: -1}}))) }

          it "returns `false`" do
            expect(expression == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(condition_expression, then_expression) }

          it "returns `true`" do
            expect(expression == other).to be(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(condition_expression, then_expression) }

      describe "#to_arguments" do
        it "returns arguments representation of `expression`" do
          expect(expression.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
