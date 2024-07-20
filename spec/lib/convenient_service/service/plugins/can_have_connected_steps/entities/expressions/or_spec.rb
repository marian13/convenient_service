# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Or, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:left_sub_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
  let(:right_sub_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step) }
  let(:expression) { described_class.new(left_sub_expression, right_sub_expression) }

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
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      it "is overridden" do
        expect { described_class.new(left_sub_expression, right_sub_expression) }.not_to raise_error
      end
    end
  end

  example_group "instance methods" do
    describe "#steps" do
      it "returns `steps` received from `each_step`" do
        expect(expression.steps).to eq(left_sub_expression.steps + right_sub_expression.steps)
      end

      specify do
        expect { expression.steps }.to delegate_to(left_sub_expression, :each_step)
      end

      specify do
        expect { expression.steps }.to delegate_to(right_sub_expression, :each_step)
      end
    end

    describe "#left_expression" do
      it "returns `left_sub_expression` passed to constructor" do
        expect(expression.left_expression).to eq(left_sub_expression)
      end
    end

    describe "#right_expression" do
      it "returns `right_sub_expression` passed to constructor" do
        expect(expression.right_expression).to eq(right_sub_expression)
      end
    end

    describe "#result" do
      context "when `left_sub_expression` is NOT `success`" do
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
          expect { expression.result }.to delegate_to(left_sub_expression, :success?)
        end

        specify do
          ##
          # NOTE: Ensures that `left_sub_expression` is evaluated.
          #
          expect { expression.result }
            .to delegate_to(left_sub_expression, :result)
            .without_arguments
        end

        specify do
          expect { expression.result }
            .to delegate_to(right_sub_expression, :result)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when `left_sub_expression` is `success`" do
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
          expect { expression.result }.to delegate_to(left_sub_expression, :success?)
        end

        specify do
          expect { expression.result }
            .to delegate_to(left_sub_expression, :result)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(right_sub_expression, :result)
        end
      end
    end

    describe "#success?" do
      context "when `left_sub_expression` is NOT `success`" do
        context "when `left_sub_expression` is `failure`" do
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
              .to delegate_to(left_sub_expression, :success?)
              .without_arguments
          end

          specify do
            expect { expression.success? }
              .to delegate_to(left_sub_expression, :error?)
              .without_arguments
          end

          specify do
            expect { expression.success? }
              .to delegate_to(right_sub_expression, :success?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `left_sub_expression` is `error`" do
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
            expect { expression.success? }
              .to delegate_to(left_sub_expression, :success?)
              .without_arguments
          end

          specify do
            expect { expression.success? }
              .to delegate_to(left_sub_expression, :error?)
                .without_arguments
                .and_return { false }
          end

          specify do
            ##
            # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.success? }.not_to delegate_to(right_sub_expression, :result)
          end
        end
      end

      context "when `left_sub_expression` is `success`" do
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
            .to delegate_to(left_sub_expression, :success?)
              .without_arguments
              .and_return { true }
        end

        specify do
          expect { expression.success? }.not_to delegate_to(left_sub_expression, :error?)
        end

        specify do
          ##
          # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
          # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
          #
          expect { expression.success? }.not_to delegate_to(right_sub_expression, :result)
        end
      end
    end

    describe "#failure?" do
      context "when `left_sub_expression` is NOT `success`" do
        context "when `left_sub_expression` is `failure`" do
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
              .to delegate_to(left_sub_expression, :success?)
              .without_arguments
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(left_sub_expression, :error?)
              .without_arguments
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(right_sub_expression, :failure?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `left_sub_expression` is `error`" do
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
              .to delegate_to(left_sub_expression, :success?)
              .without_arguments
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(left_sub_expression, :error?)
                .without_arguments
                .and_return { false }
          end

          specify do
            ##
            # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.failure? }.not_to delegate_to(right_sub_expression, :result)
          end
        end
      end

      context "when `left_sub_expression` is `success`" do
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
            .to delegate_to(left_sub_expression, :success?)
              .without_arguments
              .and_return { false }
        end

        specify do
          expect { expression.failure? }.not_to delegate_to(left_sub_expression, :error?)
        end

        specify do
          ##
          # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
          # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
          #
          expect { expression.failure? }.not_to delegate_to(right_sub_expression, :result)
        end
      end
    end

    describe "#error?" do
      context "when `left_sub_expression` is NOT `success`" do
        context "when `left_sub_expression` is `failure`" do
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
              .to delegate_to(left_sub_expression, :success?)
              .without_arguments
          end

          specify do
            expect { expression.error? }
              .to delegate_to(left_sub_expression, :error?)
              .without_arguments
          end

          specify do
            expect { expression.error? }
              .to delegate_to(right_sub_expression, :error?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `left_sub_expression` is `error`" do
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
              .to delegate_to(left_sub_expression, :success?)
              .without_arguments
          end

          specify do
            expect { expression.error? }
              .to delegate_to(left_sub_expression, :error?)
                .without_arguments
                .and_return { true }
          end

          specify do
            ##
            # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
            # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
            #
            expect { expression.error? }.not_to delegate_to(right_sub_expression, :result)
          end
        end
      end

      context "when `left_sub_expression` is `success`" do
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
            .to delegate_to(left_sub_expression, :success?)
              .without_arguments
              .and_return { false }
        end

        specify do
          expect { expression.error? }.not_to delegate_to(left_sub_expression, :error?)
        end

        specify do
          ##
          # NOTE: Ensures that `right_sub_expression` is NOT evaluated.
          # NOTE: Any of `success?`, `failure?`, and `error?` calls `result` under the hood. This reduces the possibility of the false-positive spec.
          #
          expect { expression.error? }.not_to delegate_to(right_sub_expression, :result)
        end
      end
    end

    describe "#each_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(left_sub_expression, :each_step)
          .with_arguments(&block)
      end

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(right_sub_expression, :each_step)
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
          .to delegate_to(left_sub_expression, :each_evaluated_step)
          .with_arguments(&block)
      end

      context "when `left_sub_expression` is NOT `success`" do
        context "when `left_sub_expression` is `failure`" do
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
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(right_sub_expression, :each_evaluated_step)
              .with_arguments(&block)
          end
        end

        context "when `left_sub_expression` is `error`" do
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
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(right_sub_expression, :each_evaluated_step)
          end
        end
      end

      context "when `left_sub_expression` is `success`" do
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
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(right_sub_expression, :each_evaluated_step)
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
          .with_arguments(overrides: {args: {0 => left_sub_expression.with_organizer(organizer), 1 => right_sub_expression.with_organizer(organizer)}})
          .and_return_its_value
      end
    end

    describe "#inspect" do
      it "returns inspect representation" do
        expect(expression.inspect).to eq("#{left_sub_expression.inspect} || #{right_sub_expression.inspect}")
      end
    end

    describe "#or?" do
      it "returns `true`" do
        expect(expression.or?).to eq(true)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:expression) { described_class.new(left_sub_expression, right_sub_expression) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(expression == other).to be_nil
          end
        end

        context "when `other` has different `left_sub_expression`" do
          let(:other) { described_class.new(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step.copy(overrides: {kwargs: {index: -1}})), right_sub_expression) }

          it "returns `false`" do
            expect(expression == other).to eq(false)
          end
        end

        context "when `other` has different `right_sub_expression`" do
          let(:other) { described_class.new(left_sub_expression, ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step.copy(overrides: {kwargs: {index: -1}}))) }

          it "returns `false`" do
            expect(expression == other).to eq(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(left_sub_expression, right_sub_expression) }

          it "returns `true`" do
            expect(expression == other).to eq(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(left_sub_expression, right_sub_expression) }

      describe "#to_arguments" do
        it "returns arguments representation of `expression`" do
          expect(expression.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
