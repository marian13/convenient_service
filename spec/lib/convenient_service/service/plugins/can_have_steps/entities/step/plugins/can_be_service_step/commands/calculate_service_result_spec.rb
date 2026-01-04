# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Commands::CalculateServiceResult, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  let(:middleware) { described_class }

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(step: step) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      context "when step is NOT service step" do
        let(:container) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo

            def foo
              success
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Step `#{step.printable_action}` is NOT a service step.
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Exceptions::StepIsNotServiceStep`" do
          expect { command_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Exceptions::StepIsNotServiceStep)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeServiceStep::Exceptions::StepIsNotServiceStep) { command_result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when step is service step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step,
                in: [:foo, :bar]

              def foo
                :foo
              end

              def bar
                :bar
              end
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success
            end
          end
        end

        context "when step is service step" do
          before do
            first_step.commit_config!
          end

          specify do
            expect { command_result }
              .to delegate_to(step.service_class, :result)
              .with_arguments(*step.input_arguments.args, **step.input_arguments.kwargs, &step.input_arguments.block)
              .and_return_its_value
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
