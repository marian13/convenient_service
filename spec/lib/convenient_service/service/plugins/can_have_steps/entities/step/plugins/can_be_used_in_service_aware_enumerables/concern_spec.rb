# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeUsedInServiceAwareEnumerables::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { step_class }

      let(:step_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
    end
  end

  example_group "instance methods" do
    describe "#to_service_aware_iteration_block_value" do
      let(:step) { service.new.steps.first }

      context "when step result status is `success`" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              success(foo: :foo, bar: :bar, baz: :baz)
            end
          end
        end

        context "when step has NO outputs" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step
              end
            end
          end

          it "returns `true`" do
            expect(step.to_service_aware_iteration_block_value).to be(true)
          end
        end

        context "when step has one output" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step,
                  out: :foo
              end
            end
          end

          it "returns step result data value that corresponds to that one output" do
            expect(step.to_service_aware_iteration_block_value).to eq(:foo)
          end

          context "when step result does NOT have value for that one output" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(first_step) do |first_step|
                  include ConvenientService::Standard::Config

                  step first_step,
                    out: :qux
                end
              end
            end

            let(:exception_message) do
              <<~TEXT
                Step `#{step.printable_action}` result does NOT return `:qux` data attribute.

                Maybe there is a typo in `out` definition?

                Or `success` of `#{step.printable_action}` accepts a wrong key?
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute`" do
              expect { step.to_service_aware_iteration_block_value }
                .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute)
                .with_message(exception_message)
            end
          end
        end

        context "when step has many outputs" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step,
                  out: [:foo, :bar]
              end
            end
          end

          it "returns step result data values that corresponds to those many outputs" do
            expect(step.to_service_aware_iteration_block_value).to eq({foo: :foo, bar: :bar})
          end

          context "when step result does NOT have any value for those many output" do
            let(:service) do
              Class.new.tap do |klass|
                klass.class_exec(first_step) do |first_step|
                  include ConvenientService::Standard::Config

                  step first_step,
                    out: [:foo, :qux]
                end
              end
            end

            let(:exception_message) do
              <<~TEXT
                Step `#{step.printable_action}` result does NOT return `:qux` data attribute.

                Maybe there is a typo in `out` definition?

                Or `success` of `#{step.printable_action}` accepts a wrong key?
              TEXT
            end

            it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute`" do
              expect { step.to_service_aware_iteration_block_value }
                .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepResultDataNotExistingAttribute)
                .with_message(exception_message)
            end
          end
        end
      end

      context "when result status is `failure`" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              failure("from first step")
            end
          end
        end

        context "when step has NO outputs" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step
              end
            end
          end

          it "returns `false`" do
            expect(step.to_service_aware_iteration_block_value).to be(false)
          end
        end

        context "when step has one output" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step,
                  out: :foo
              end
            end
          end

          it "returns `nil`" do
            expect(step.to_service_aware_iteration_block_value).to be_nil
          end
        end

        context "when step has many outputs" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step,
                  out: [:foo, :bar]
              end
            end
          end

          it "returns `nil`" do
            expect(step.to_service_aware_iteration_block_value).to be_nil
          end
        end
      end

      context "when result status is `error`" do
        let(:first_step) do
          Class.new do
            include ConvenientService::Standard::Config

            def result
              error("from first step")
            end
          end
        end

        context "when step has NO outputs" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step
              end
            end
          end

          it "throws `:propagated_result`" do
            expect { step.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: step.result})
          end
        end

        context "when step has one output" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step,
                  out: :foo
              end
            end
          end

          it "throws `:propagated_result`" do
            expect { step.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: step.result})
          end
        end

        context "when step has many outputs" do
          let(:service) do
            Class.new.tap do |klass|
              klass.class_exec(first_step) do |first_step|
                include ConvenientService::Standard::Config

                step first_step,
                  out: [:foo, :bar]
              end
            end
          end

          it "throws `:propagated_result`" do
            expect { step.to_service_aware_iteration_block_value }.to throw_symbol(:propagated_result, {propagated_result: step.result})
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
