# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::DefineMethodInContainer, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:organizer) { container.new }

  let(:first_step_service) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success(data: {foo: "foo from first step"})
      end
    end
  end

  let(:second_step_service) do
    Class.new do
      include ConvenientService::Standard::Config

      def result
        success(data: {foo: "foo from second step"})
      end
    end
  end

  let(:step) { container.steps.first }
  let(:method) { container.steps.first.outputs.first }

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(method: method, container: step.container, index: step.index) }

      context "when `out` method is NOT defined in container" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step_service) do |first_step_service|
              include ConvenientService::Standard::Config

              step first_step_service, out: :foo
            end
          end
        end

        it "returns `true`" do
          expect(command_result).to be(true)
        end
      end

      context "when `out` method is defined in container by user" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step_service) do |first_step_service|
              include ConvenientService::Standard::Config

              step first_step_service, out: :foo

              def foo
                "foo from organizer"
              end
            end
          end
        end

        it "returns `true`" do
          expect(command_result).to be(true)
        end
      end

      context "when `out` method is defined in container by `DefineMethodInContainer` command" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step_service) do |first_step_service|
              include ConvenientService::Standard::Config

              step first_step_service, out: :foo
            end
          end
        end

        before do
          ##
          # NOTE: Defines `out` method.
          #
          described_class.call(method: method, container: step.container, index: step.index)
        end

        it "returns `false`" do
          expect(command_result).to be(false)
        end
      end

      example_group "generated method" do
        before do
          command_result
        end

        context "when `out` method does NOT have alias" do
          context "when corresponding step is NOT completed" do
            context "when corresponding `out` method is NOT redefined (organizer service does NOT have method with same nameas `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  `out` method `#{method}` is called before its corresponding step is completed.

                  Maybe it makes sense to change steps order?
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted`" do
                expect { organizer.foo }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted) { organizer.foo } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when corresponding `out` method is redefined (organizer service has method with same name as `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo

                    def foo
                      "foo from organizer"
                    end
                  end
                end
              end

              it "returns that method value" do
                expect(organizer.foo).to eq("foo from organizer")
              end

              specify do
                expect { organizer.foo }
                  .to delegate_to(organizer, :foo_before_out_redefinition)
                  .without_arguments
                  .and_return_its_value
              end
            end

            context "when corresponding `out` method is redefined multiple times" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service, second_step_service) do |first_step_service, second_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo

                    step second_step_service, out: :foo

                    def foo
                      "foo from organizer"
                    end
                  end
                end
              end

              it "returns that method value" do
                expect(organizer.foo).to eq("foo from organizer")
              end

              specify do
                expect { organizer.foo }
                  .to delegate_to(organizer, :foo_before_out_redefinition)
                  .without_arguments
                  .and_return_its_value
              end
            end
          end

          context "when corresponding step is completed" do
            context "when corresponding `out` method is NOT redefined (organizer service does NOT have method with same nameas `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo
                  end
                end
              end

              before do
                ##
                # NOTE: Completes the step.
                #
                organizer.steps[0].save_outputs_in_organizer!
              end

              it "returns corresponding step service result data attribute by key" do
                expect(organizer.foo).to eq("foo from first step")
              end
            end

            context "when corresponding `out` method is redefined (organizer service does NOT have method with same nameas `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo

                    def foo
                      "foo from organizer"
                    end
                  end
                end
              end

              before do
                ##
                # NOTE: Completes the step.
                #
                organizer.steps[0].save_outputs_in_organizer!
              end

              it "returns corresponding step service result data attribute by key" do
                expect(organizer.foo).to eq("foo from first step")
              end
            end

            context "when corresponding `out` method is redefined multiple times" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service, second_step_service) do |first_step_service, second_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo

                    step second_step_service, out: :foo

                    def foo
                      "foo from organizer"
                    end
                  end
                end
              end

              before do
                ##
                # NOTE: Completes the step.
                #
                organizer.steps[0].save_outputs_in_organizer!
                organizer.steps[1].save_outputs_in_organizer!
              end

              it "returns corresponding step service result data attribute by key" do
                expect(organizer.foo).to eq("foo from second step")
              end
            end
          end
        end

        context "when `out` method has alias" do
          context "when corresponding step is NOT completed" do
            context "when corresponding `out` method is NOT redefined (organizer service does NOT have method with same nameas `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: {foo: :bar}
                  end
                end
              end

              let(:exception_message) do
                <<~TEXT
                  `out` method `#{method}` is called before its corresponding step is completed.

                  Maybe it makes sense to change steps order?
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted`" do
                expect { organizer.bar }
                  .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted)
                  .with_message(exception_message)
              end

              specify do
                expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted) { organizer.bar } }
                  .to delegate_to(ConvenientService, :raise)
              end
            end

            context "when corresponding `out` method is redefined (organizer service has method with same name as `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: {foo: :bar}

                    def bar
                      "bar from organizer"
                    end
                  end
                end
              end

              it "returns that method value" do
                expect(organizer.bar).to eq("bar from organizer")
              end

              specify do
                expect { organizer.bar }
                  .to delegate_to(organizer, :bar_before_out_redefinition)
                  .without_arguments
                  .and_return_its_value
              end
            end

            context "when corresponding `out` method is redefined multiple times" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service, second_step_service) do |first_step_service, second_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: {foo: :bar}

                    step second_step_service, out: {foo: :bar}

                    def bar
                      "bar from organizer"
                    end
                  end
                end
              end

              it "returns that method value" do
                expect(organizer.bar).to eq("bar from organizer")
              end

              specify do
                expect { organizer.bar }
                  .to delegate_to(organizer, :bar_before_out_redefinition)
                  .without_arguments
                  .and_return_its_value
              end
            end
          end

          context "when corresponding step is completed" do
            context "when corresponding `out` method is NOT redefined (organizer service does NOT have method with same nameas `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: {foo: :bar}
                  end
                end
              end

              before do
                ##
                # NOTE: Completes the step.
                #
                organizer.steps[0].save_outputs_in_organizer!
              end

              it "returns corresponding step service result data attribute by key" do
                expect(organizer.bar).to eq("foo from first step")
              end
            end

            context "when corresponding `out` method is redefined (organizer service does NOT have method with same nameas `out` method)" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service) do |first_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: {foo: :bar}

                    def bar
                      "bar from organizer"
                    end
                  end
                end
              end

              before do
                ##
                # NOTE: Completes the step.
                #
                organizer.steps[0].save_outputs_in_organizer!
              end

              it "returns corresponding step service result data attribute by key" do
                expect(organizer.bar).to eq("foo from first step")
              end
            end

            context "when corresponding `out` method is redefined multiple times" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service, second_step_service) do |first_step_service, second_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: {foo: :bar}

                    step second_step_service, out: {foo: :bar}

                    def bar
                      "bar from organizer"
                    end
                  end
                end
              end

              before do
                ##
                # NOTE: Completes the step.
                #
                organizer.steps[0].save_outputs_in_organizer!
                organizer.steps[1].save_outputs_in_organizer!
              end

              it "returns corresponding step service result data attribute by key" do
                expect(organizer.bar).to eq("foo from second step")
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
