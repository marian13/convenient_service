# frozen_string_literal: true

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

  let(:step) { container.steps.first }
  let(:method) { container.steps.first.outputs.first }

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(method: method, container: step.container, index: step.index) }

      context "when `method` is NOT defined in container" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step_service) do |first_step_service|
              include ConvenientService::Standard::Config

              step first_step_service, out: :foo
            end
          end
        end

        it "returns `true`" do
          expect(command_result).to eq(true)
        end

        it "defines `method` in `container`" do
          expect { command_result }.to change { ConvenientService::Utils::Method.defined?(method.name.to_s, step.container.klass, private: true) }.from(false).to(true)
        end

        example_group "generated method" do
          before do
            command_result
          end

          context "when corresponding step is NOT completed" do
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

          context "when corresponding step is completed" do
            before do
              ##
              # NOTE: Completes the step.
              #
              organizer.steps[0].save_outputs_in_organizer!
            end

            it "returns corresponding step service result data attribute by key" do
              expect(organizer.foo).to eq(organizer.steps[0].result.unsafe_data[:foo])
            end

            context "when multiple corresponding steps are completed" do
              let(:container) do
                Class.new.tap do |klass|
                  klass.class_exec(first_step_service, second_step_service) do |first_step_service, second_step_service|
                    include ConvenientService::Standard::Config

                    step first_step_service, out: :foo

                    step second_step_service, out: :foo
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

              before do
                ##
                # NOTE: Completes the steps.
                #
                organizer.steps[0].save_outputs_in_organizer!
                organizer.steps[1].save_outputs_in_organizer!
              end

              it "returns last corresponding step service result data attribute by key" do
                expect(organizer.foo).to eq(organizer.steps[1].result.unsafe_data[:foo])
              end
            end
          end

          context "when method has alias" do
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
              expect(organizer.bar).to eq(organizer.steps[0].result.unsafe_data[:bar])
            end
          end
        end
      end

      context "when `method` is defined in container" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step_service) do |first_step_service|
              include ConvenientService::Standard::Config

              step first_step_service, out: :foo

              def foo
                :foo
              end
            end
          end
        end

        it "returns `false`" do
          described_class.call(method: method, container: step.container, index: step.index)

          expect(command_result).to eq(false)
        end

        it "does NOT define `method` in `container`" do
          expect { command_result }.not_to change { ConvenientService::Utils::Method.defined?(method.name.to_s, step.container.klass, private: true) }
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
