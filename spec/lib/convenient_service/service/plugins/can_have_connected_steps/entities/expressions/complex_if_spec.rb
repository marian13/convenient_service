# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::ComplexIf, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:first_if_expression_condition_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(first_step) }
  let(:first_if_expression_then_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(second_step) }

  let(:second_if_expression_condition_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(third_step) }
  let(:second_if_expression_then_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(forth_step) }

  let(:third_if_expression_condition_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(fifth_step) }
  let(:third_if_expression_then_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(sixth_step) }

  let(:else_expression_sub_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar.new(seventh_step) }

  let(:if_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(first_if_expression_condition_expression, first_if_expression_then_expression) }
  let(:elsif_expressions) { [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression)] }
  let(:else_expression) { ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Else.new(else_expression_sub_expression) }

  let(:expression) { described_class.new(if_expression, elsif_expressions, else_expression) }

  let(:container) do
    Class.new do
      include ConvenientService::Standard::Config

      step :foo
      step :bar
      step :baz
      step :qux
      step :quux
      step :quuz
      step :cargo

      def foo
        success(data: {from: :foo})
      end

      def bar
        success(data: {from: :bar})
      end

      def baz
        success(data: {from: :baz})
      end

      def qux
        success(data: {from: :qux})
      end

      def quux
        success(data: {from: :quux})
      end

      def quuz
        success(data: {from: :quuz})
      end

      def cargo
        success(data: {from: :cargo})
      end
    end
  end

  let(:organizer) { container.new }

  let(:first_step) { organizer.steps[0] }
  let(:second_step) { organizer.steps[1] }
  let(:third_step) { organizer.steps[2] }
  let(:forth_step) { organizer.steps[3] }
  let(:fifth_step) { organizer.steps[4] }
  let(:sixth_step) { organizer.steps[5] }
  let(:seventh_step) { organizer.steps[6] }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      it "is overridden" do
        expect { described_class.new(if_expression, elsif_expressions, else_expression) }.not_to raise_error
      end
    end
  end

  example_group "instance methods" do
    describe "#steps" do
      it "returns `steps` received from `each_step`" do
        expect(expression.steps).to eq(if_expression.steps + elsif_expressions.first.steps + else_expression.steps)
      end

      specify do
        expect { expression.steps }.to delegate_to(if_expression, :each_step)
      end

      specify do
        expect { expression.steps }.to delegate_to(elsif_expressions.first, :each_step)
      end

      specify do
        expect { expression.steps }.to delegate_to(else_expression, :each_step)
      end

      context "when `expression` does NOT have `else_expression`" do
        let(:else_expression) { nil }

        it "returns `steps` received from `each_step`" do
          expect(expression.steps).to eq(if_expression.steps + elsif_expressions.first.steps)
        end

        specify do
          expect { expression.steps }.to delegate_to(if_expression, :each_step)
        end

        specify do
          expect { expression.steps }.to delegate_to(elsif_expressions.first, :each_step)
        end
      end

      context "when `expression` does NOT have `elsif_expressions`" do
        let(:elsif_expressions) { [] }

        it "returns `steps` received from `each_step`" do
          expect(expression.steps).to eq(if_expression.steps + else_expression.steps)
        end

        specify do
          expect { expression.steps }.to delegate_to(if_expression, :each_step)
        end

        specify do
          expect { expression.steps }.to delegate_to(else_expression, :each_step)
        end
      end

      context "when `expression` has multiple `elsif_expressions`" do
        let(:elsif_expressions) do
          [
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
          ]
        end

        it "returns `steps` received from `each_step`" do
          expect(expression.steps).to eq(if_expression.steps + elsif_expressions[0].steps + elsif_expressions[1].steps + else_expression.steps)
        end

        specify do
          expect { expression.steps }.to delegate_to(if_expression, :each_step)
        end

        specify do
          expect { expression.steps }.to delegate_to(elsif_expressions[0], :each_step)
        end

        specify do
          expect { expression.steps }.to delegate_to(elsif_expressions[1], :each_step)
        end

        specify do
          expect { expression.steps }.to delegate_to(else_expression, :each_step)
        end
      end
    end

    describe "#if_expression" do
      it "returns `if_expression` passed to constructor" do
        expect(expression.if_expression).to eq(if_expression)
      end
    end

    describe "#elsif_expressions" do
      it "returns `elsif_expressions` passed to constructor" do
        expect(expression.elsif_expressions).to eq(elsif_expressions)
      end
    end

    describe "#else_expression" do
      it "returns `else_expression` passed to constructor" do
        expect(expression.else_expression).to eq(else_expression)
      end
    end

    describe "#result" do
      let(:expression) { described_class.new(if_expression, elsif_expressions, else_expression) }

      context "when `if_expression.condition_expression` is `error`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              error(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.result }
            .to delegate_to(if_expression.condition_expression, :result)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
        end
      end

      context "when `if_expression.condition_expression` is `failure`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                error(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.result }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.result }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
              .and_return_its_value
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                failure(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.result }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.result }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            expect { expression.result }
              .to delegate_to(else_expression.expression, :result)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `success`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.result }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.result }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            expect { expression.result }
              .to delegate_to(elsif_expressions.first.then_expression, :result)
              .without_arguments
              .and_return_its_value
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `expression` does NOT have `else_expression`" do
          let(:else_expression) { nil }

          context "when `elsif_expressions.first.condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.result }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
                .and_return_its_value
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `failure`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  failure(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.result }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .to delegate_to(expression.organizer, :success)
                .without_arguments
                .and_return_its_value
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.result }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions.first.then_expression, :result)
                .without_arguments
                .and_return_its_value
            end
          end
        end

        context "when `expression` does NOT have `elsif_expressions`" do
          let(:elsif_expressions) { [] }

          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.result }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.result }
              .to delegate_to(else_expression.expression, :result)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `expression` has multiple `elsif_expressions`" do
          let(:elsif_expressions) do
            [
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
            ]
          end

          context "when `elsif_expressions[0].condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.result }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                .without_arguments
                .and_return_its_value
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `failure`" do
            context "when `elsif_expressions[1].condition_expression` is `error`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    error(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.result }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
                  .and_return_its_value
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `failure`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    failure(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.result }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(else_expression.expression, :result)
                  .without_arguments
                  .and_return_its_value
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `success`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    success(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.result }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                expect { expression.result }
                  .to delegate_to(elsif_expressions[1].then_expression, :result)
                  .without_arguments
                  .and_return_its_value
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
              end
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.result }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.result }
                .to delegate_to(elsif_expressions[0].then_expression, :result)
                .without_arguments
                .and_return_its_value
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
            end
          end
        end
      end

      context "when `if_expression.condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.result }
            .to delegate_to(if_expression.condition_expression, :result)
            .without_arguments
        end

        specify do
          expect { expression.result }
            .to delegate_to(if_expression.then_expression, :result)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.result }.not_to delegate_to(else_expression.expression, :result)
        end
      end
    end

    describe "#organizer" do
      specify do
        expect { expression.organizer }
          .to delegate_to(if_expression, :organizer)
          .without_arguments
          .and_return_its_value
      end
    end

    describe "#success?" do
      context "when `if_expression.condition_expression` is `error`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              error(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.success? }
            .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
              .and_return { false }
        end

        specify do
          ##
          # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
        end
      end

      context "when `if_expression.condition_expression` is `failure`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                error(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.success? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.success? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
                .and_return { false }
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                failure(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.success? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.success? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            expect { expression.success? }
              .to delegate_to(else_expression.expression, :success?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `success`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.success? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.success? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            expect { expression.success? }
              .to delegate_to(elsif_expressions.first.then_expression, :success?)
              .without_arguments
              .and_return_its_value
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `expression` does NOT have `else_expression`" do
          let(:else_expression) { nil }

          context "when `elsif_expressions.first.condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.success? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                  .without_arguments
                  .and_return { false }
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `failure`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  failure(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.success? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .not_to delegate_to(expression.organizer, :success)
                  .without_arguments
                  .and_return { true }
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.success? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions.first.then_expression, :success?)
                .without_arguments
                .and_return_its_value
            end
          end
        end

        context "when `expression` does NOT have `elsif_expressions`" do
          let(:elsif_expressions) { [] }

          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.success? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.success? }
              .to delegate_to(else_expression.expression, :success?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `expression` has multiple `elsif_expressions`" do
          let(:elsif_expressions) do
            [
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
            ]
          end

          context "when `elsif_expressions[0].condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.success? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
                  .and_return { false }
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `failure`" do
            context "when `elsif_expressions[1].condition_expression` is `error`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    error(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                    .without_arguments
                    .and_return { false }
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `failure`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    failure(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(else_expression.expression, :success?)
                  .without_arguments
                  .and_return_its_value
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `success`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    success(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                expect { expression.success? }
                  .to delegate_to(elsif_expressions[1].then_expression, :success?)
                  .without_arguments
                  .and_return_its_value
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
              end
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.success? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.success? }
                .to delegate_to(elsif_expressions[0].then_expression, :success?)
                .without_arguments
                .and_return_its_value
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
            end
          end
        end
      end

      context "when `if_expression.condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.success? }
            .to delegate_to(if_expression.condition_expression, :result)
            .without_arguments
        end

        specify do
          expect { expression.success? }
            .to delegate_to(if_expression.then_expression, :success?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.success? }.not_to delegate_to(else_expression.expression, :result)
        end
      end
    end

    describe "#failure?" do
      context "when `if_expression.condition_expression` is `error`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              error(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.failure? }
            .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
              .and_return { false }
        end

        specify do
          ##
          # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
        end
      end

      context "when `if_expression.condition_expression` is `failure`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                error(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
                .and_return { false }
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                failure(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(else_expression.expression, :failure?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `success`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(elsif_expressions.first.then_expression, :failure?)
              .without_arguments
              .and_return_its_value
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `expression` does NOT have `else_expression`" do
          let(:else_expression) { nil }

          context "when `elsif_expressions.first.condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                  .without_arguments
                  .and_return { false }
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `failure`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  failure(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .not_to delegate_to(expression.organizer, :success)
                  .without_arguments
                  .and_return { false }
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions.first.then_expression, :failure?)
                .without_arguments
                .and_return_its_value
            end
          end
        end

        context "when `expression` does NOT have `elsif_expressions`" do
          let(:elsif_expressions) { [] }

          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.failure? }
              .to delegate_to(else_expression.expression, :failure?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `expression` has multiple `elsif_expressions`" do
          let(:elsif_expressions) do
            [
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
            ]
          end

          context "when `elsif_expressions[0].condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
                  .and_return { false }
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `failure`" do
            context "when `elsif_expressions[1].condition_expression` is `error`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    error(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                    .without_arguments
                    .and_return { false }
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `failure`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    failure(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(else_expression.expression, :failure?)
                  .without_arguments
                  .and_return_its_value
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `success`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    success(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                expect { expression.failure? }
                  .to delegate_to(elsif_expressions[1].then_expression, :failure?)
                  .without_arguments
                  .and_return_its_value
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
              end
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.failure? }
                .to delegate_to(elsif_expressions[0].then_expression, :failure?)
                .without_arguments
                .and_return_its_value
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
            end
          end
        end
      end

      context "when `if_expression.condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.failure? }
            .to delegate_to(if_expression.condition_expression, :result)
            .without_arguments
        end

        specify do
          expect { expression.failure? }
            .to delegate_to(if_expression.then_expression, :failure?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.failure? }.not_to delegate_to(else_expression.expression, :result)
        end
      end
    end

    describe "#error?" do
      context "when `if_expression.condition_expression` is `error`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              error(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.error? }
            .to delegate_to(if_expression.condition_expression, :error?)
              .without_arguments
              .and_return { true }
        end

        specify do
          ##
          # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
        end
      end

      context "when `if_expression.condition_expression` is `failure`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                error(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.error? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.error? }
              .to delegate_to(elsif_expressions.first.condition_expression, :error?)
                .without_arguments
                .and_return { true }
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                failure(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.error? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.error? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            expect { expression.error? }
              .to delegate_to(else_expression.expression, :error?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `success`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.error? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.error? }
              .to delegate_to(elsif_expressions.first.condition_expression, :result)
              .without_arguments
          end

          specify do
            expect { expression.error? }
              .to delegate_to(elsif_expressions.first.then_expression, :error?)
              .without_arguments
              .and_return_its_value
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `expression` does NOT have `else_expression`" do
          let(:else_expression) { nil }

          context "when `elsif_expressions.first.condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.error? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                  .without_arguments
                  .and_return { true }
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `failure`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  failure(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.error? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
            end

            specify do
              expect { expression.result }
                .not_to delegate_to(expression.organizer, :success)
                  .without_arguments
                  .and_return { false }
            end
          end

          context "when `elsif_expressions.first.condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.error? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions.first.condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions.first.then_expression, :error?)
                .without_arguments
                .and_return_its_value
            end
          end
        end

        context "when `expression` does NOT have `elsif_expressions`" do
          let(:elsif_expressions) { [] }

          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.error? }
              .to delegate_to(if_expression.condition_expression, :result)
              .without_arguments
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.error? }
              .to delegate_to(else_expression.expression, :error?)
              .without_arguments
              .and_return_its_value
          end
        end

        context "when `expression` has multiple `elsif_expressions`" do
          let(:elsif_expressions) do
            [
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
              ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
            ]
          end

          context "when `elsif_expressions[0].condition_expression` is `error`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  error(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.error? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
                  .and_return { true }
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `failure`" do
            context "when `elsif_expressions[1].condition_expression` is `error`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    error(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                    .without_arguments
                    .and_return { true }
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `failure`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    failure(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(else_expression.expression, :error?)
                  .without_arguments
                  .and_return_its_value
              end
            end

            context "when `elsif_expressions[1].condition_expression` is `success`" do
              let(:container) do
                Class.new do
                  include ConvenientService::Standard::Config

                  step :foo
                  step :bar
                  step :baz
                  step :qux
                  step :quux
                  step :quuz
                  step :cargo

                  def foo
                    failure(data: {from: :foo})
                  end

                  def bar
                    success(data: {from: :bar})
                  end

                  def baz
                    failure(data: {from: :baz})
                  end

                  def qux
                    success(data: {from: :qux})
                  end

                  def quux
                    success(data: {from: :quux})
                  end

                  def quuz
                    success(data: {from: :quuz})
                  end

                  def cargo
                    success(data: {from: :cargo})
                  end
                end
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(if_expression.condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[0].condition_expression, :result)
                  .without_arguments
              end

              specify do
                ##
                # NOTE: Ensures that `elsif_expressions[0].then_expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(elsif_expressions[0].then_expression, :result)
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[1].condition_expression, :result)
                  .without_arguments
              end

              specify do
                expect { expression.error? }
                  .to delegate_to(elsif_expressions[1].then_expression, :error?)
                  .without_arguments
                  .and_return_its_value
              end

              specify do
                ##
                # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
                #
                expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
              end
            end
          end

          context "when `elsif_expressions[0].condition_expression` is `success`" do
            let(:container) do
              Class.new do
                include ConvenientService::Standard::Config

                step :foo
                step :bar
                step :baz
                step :qux
                step :quux
                step :quuz
                step :cargo

                def foo
                  failure(data: {from: :foo})
                end

                def bar
                  success(data: {from: :bar})
                end

                def baz
                  success(data: {from: :baz})
                end

                def qux
                  success(data: {from: :qux})
                end

                def quux
                  success(data: {from: :quux})
                end

                def quuz
                  success(data: {from: :quuz})
                end

                def cargo
                  success(data: {from: :cargo})
                end
              end
            end

            specify do
              expect { expression.error? }
                .to delegate_to(if_expression.condition_expression, :result)
                .without_arguments
            end

            specify do
              ##
              # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(if_expression.then_expression, :result)
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions[0].condition_expression, :result)
                .without_arguments
            end

            specify do
              expect { expression.error? }
                .to delegate_to(elsif_expressions[0].then_expression, :error?)
                .without_arguments
                .and_return_its_value
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].condition_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions[1].condition_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `elsif_expressions[1].then_expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(elsif_expressions[1].then_expression, :result)
            end

            specify do
              ##
              # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
              #
              expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
            end
          end
        end
      end

      context "when `if_expression.condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.error? }
            .to delegate_to(if_expression.condition_expression, :result)
            .without_arguments
        end

        specify do
          expect { expression.error? }
            .to delegate_to(if_expression.then_expression, :error?)
            .without_arguments
            .and_return_its_value
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.error? }.not_to delegate_to(else_expression.expression, :result)
        end
      end
    end

    describe "#each_step" do
      let(:block) { proc { |step| step.index } }

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(if_expression, :each_step)
          .with_arguments(&block)
      end

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(elsif_expressions.first, :each_step)
          .with_arguments(&block)
      end

      specify do
        expect { expression.each_step(&block) }
          .to delegate_to(else_expression, :each_step)
          .with_arguments(&block)
      end

      it "returns `expression`" do
        expect(expression.each_step(&block)).to eq(expression)
      end

      context "when `expression` does NOT have `else_expression`" do
        let(:else_expression) { nil }

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(if_expression, :each_step)
            .with_arguments(&block)
        end

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(elsif_expressions.first, :each_step)
            .with_arguments(&block)
        end
      end

      context "when `expression` does NOT have `elsif_expressions`" do
        let(:elsif_expressions) { [] }

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(if_expression, :each_step)
            .with_arguments(&block)
        end

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(else_expression, :each_step)
            .with_arguments(&block)
        end
      end

      context "when `expression` has multiple `elsif_expressions`" do
        let(:elsif_expressions) do
          [
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
          ]
        end

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(if_expression, :each_step)
            .with_arguments(&block)
        end

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(elsif_expressions[0], :each_step)
            .with_arguments(&block)
        end

        specify do
          expect { expression.each_step(&block) }
            .to delegate_to(elsif_expressions[1], :each_step)
            .with_arguments(&block)
        end
      end
    end

    describe "#each_evaluated_step" do
      let(:block) { proc { |step| step.index } }

      context "when `if_expression.condition_expression` is `error`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              error(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.each_evaluated_step(&block) }
            .to delegate_to(if_expression.condition_expression, :each_evaluated_step)
            .with_arguments(&block)
        end

        specify do
          ##
          # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(if_expression.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(else_expression.expression, :result)
        end
      end

      context "when `if_expression.condition_expression` is `failure`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              failure(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `error`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                error(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(if_expression.condition_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(elsif_expressions.first.condition_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(else_expression.expression, :result)
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `failure`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                failure(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(if_expression.condition_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(elsif_expressions.first.condition_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            ##
            # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(else_expression.expression, :each_evaluated_step)
              .with_arguments(&block)
          end
        end

        context "when `elsif_expressions.first.condition_expression` is `success`" do
          let(:container) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo
              step :bar
              step :baz
              step :qux
              step :quux
              step :quuz
              step :cargo

              def foo
                failure(data: {from: :foo})
              end

              def bar
                success(data: {from: :bar})
              end

              def baz
                success(data: {from: :baz})
              end

              def qux
                success(data: {from: :qux})
              end

              def quux
                success(data: {from: :quux})
              end

              def quuz
                success(data: {from: :quuz})
              end

              def cargo
                success(data: {from: :cargo})
              end
            end
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(if_expression.condition_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            ##
            # NOTE: Ensures that `if_expression.then_expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(if_expression.then_expression, :result)
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(elsif_expressions.first.condition_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            expect { expression.each_evaluated_step(&block) }
              .to delegate_to(elsif_expressions.first.then_expression, :each_evaluated_step)
              .with_arguments(&block)
          end

          specify do
            ##
            # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
            #
            expect { expression.each_evaluated_step(&block) }.not_to delegate_to(else_expression.expression, :result)
          end
        end
      end

      context "when `if_expression.condition_expression` is `success`" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo
            step :bar
            step :baz
            step :qux
            step :quux
            step :quuz
            step :cargo

            def foo
              success(data: {from: :foo})
            end

            def bar
              success(data: {from: :bar})
            end

            def baz
              success(data: {from: :baz})
            end

            def qux
              success(data: {from: :qux})
            end

            def quux
              success(data: {from: :quux})
            end

            def quuz
              success(data: {from: :quuz})
            end

            def cargo
              success(data: {from: :cargo})
            end
          end
        end

        specify do
          expect { expression.each_evaluated_step(&block) }
            .to delegate_to(if_expression.condition_expression, :each_evaluated_step)
            .with_arguments(&block)
        end

        specify do
          expect { expression.each_evaluated_step(&block) }
            .to delegate_to(if_expression.then_expression, :each_evaluated_step)
            .with_arguments(&block)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.condition_expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(elsif_expressions.first.condition_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `elsif_expressions.first.then_expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(elsif_expressions.first.then_expression, :result)
        end

        specify do
          ##
          # NOTE: Ensures that `else_expression.expression` is NOT evaluated.
          #
          expect { expression.each_evaluated_step(&block) }.not_to delegate_to(else_expression.expression, :result)
        end
      end
    end

    describe "#with_organizer" do
      specify do
        expect { expression.with_organizer(organizer) }
          .to delegate_to(expression, :copy)
          .with_arguments(overrides: {args: {0 => if_expression.with_organizer(organizer), 1 => elsif_expressions.map { |elsif_expression| elsif_expression.with_organizer(organizer) }, 2 => else_expression.with_organizer(organizer)}})
          .and_return_its_value
      end
    end

    describe "#inspect" do
      let(:representation) do
        [
          "if #{if_expression.condition_expression.inspect}",
          "then #{if_expression.then_expression.inspect}",
          "elsif #{elsif_expressions[0].condition_expression.inspect}",
          "then #{elsif_expressions[0].then_expression.inspect}",
          "else #{else_expression.expression.inspect}",
          "end"
        ]
          .join(" ")
      end

      it "returns inspect representation" do
        expect(expression.inspect).to eq(representation)
      end

      context "when `expression` does NOT have `else_expression`" do
        let(:else_expression) { nil }

        let(:representation) do
          [
            "if #{if_expression.condition_expression.inspect}",
            "then #{if_expression.then_expression.inspect}",
            "elsif #{elsif_expressions[0].condition_expression.inspect}",
            "then #{elsif_expressions[0].then_expression.inspect}",
            "end"
          ]
            .join(" ")
        end

        it "returns inspect representation" do
          expect(expression.inspect).to eq(representation)
        end
      end

      context "when `expression` does NOT have `elsif_expressions`" do
        let(:elsif_expressions) { [] }

        let(:representation) do
          [
            "if #{if_expression.condition_expression.inspect}",
            "then #{if_expression.then_expression.inspect}",
            "else #{else_expression.expression.inspect}",
            "end"
          ]
            .join(" ")
        end

        it "returns inspect representation" do
          expect(expression.inspect).to eq(representation)
        end
      end

      context "when `expression` has multiple `elsif_expressions`" do
        let(:elsif_expressions) do
          [
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression),
            ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(third_if_expression_condition_expression, third_if_expression_then_expression)
          ]
        end

        let(:representation) do
          [
            "if #{if_expression.condition_expression.inspect}",
            "then #{if_expression.then_expression.inspect}",
            "elsif #{elsif_expressions[0].condition_expression.inspect}",
            "then #{elsif_expressions[0].then_expression.inspect}",
            "elsif #{elsif_expressions[1].condition_expression.inspect}",
            "then #{elsif_expressions[1].then_expression.inspect}",
            "else #{else_expression.expression.inspect} end"
          ]
            .join(" ")
        end

        it "returns inspect representation" do
          expect(expression.inspect).to eq(representation)
        end
      end
    end

    describe "#complex_if?" do
      it "returns `true`" do
        expect(expression.complex_if?).to be(true)
      end
    end

    example_group "comparison" do
      describe "#==" do
        let(:expression) { described_class.new(if_expression, elsif_expressions, else_expression) }

        context "when `other` has different class" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(expression == other).to be_nil
          end
        end

        context "when `other` has different `if_expression`" do
          let(:other) { described_class.new(ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(second_if_expression_condition_expression, second_if_expression_then_expression), elsif_expressions, else_expression) }

          it "returns `false`" do
            expect(expression == other).to be(false)
          end
        end

        context "when `other` has different `elsif_expressions`" do
          let(:other) { described_class.new(if_expression, [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If.new(first_if_expression_condition_expression, first_if_expression_then_expression)], else_expression) }

          it "returns `false`" do
            expect(expression == other).to be(false)
          end
        end

        context "when `other` has different `else_expression`" do
          let(:other) { described_class.new(if_expression, elsif_expressions, nil) }

          it "returns `false`" do
            expect(expression == other).to be(false)
          end
        end

        context "when `other` has same attributes" do
          let(:other) { described_class.new(if_expression, elsif_expressions, else_expression) }

          it "returns `true`" do
            expect(expression == other).to be(true)
          end
        end
      end
    end

    example_group "conversions" do
      let(:arguments) { ConvenientService::Support::Arguments.new(if_expression, elsif_expressions, else_expression) }

      describe "#to_arguments" do
        it "returns arguments representation of `expression`" do
          expect(expression.to_arguments).to eq(arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
