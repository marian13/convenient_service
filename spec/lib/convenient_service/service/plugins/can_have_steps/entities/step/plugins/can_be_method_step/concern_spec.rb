# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    ##
    # TODO: Custom matcher. This code is repeated too often.
    #
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
    let(:service_class) do
      Class.new do
        include ConvenientService::Standard::Config

        step :foo

        def foo
          success
        end
      end
    end

    let(:first_step) do
      Class.new do
        include ConvenientService::Standard::Config

        step :result

        def result
          success
        end
      end
    end

    let(:service_instance) { service_class.new }

    let(:step) { service_instance.steps.first }

    describe "#method" do
      context "when `step` is NOT method step" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        it "returns `nil`" do
          expect(step.method).to be_nil
        end
      end

      context "when `step` is method step" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo

            def foo
              success
            end
          end
        end

        specify do
          expect { step.method }
            .to delegate_to(step, :action)
            .without_arguments
            .and_return_its_value
        end
      end
    end

    describe "#method_step?" do
      context "when `step` action is NOT instance of `Symbol`" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        it "returns `false`" do
          expect(step.method_step?).to eq(false)
        end
      end

      context "when `step` action is instance of `Symbol`" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            step :foo

            def foo
              success
            end
          end
        end

        it "returns `true`" do
          expect(step.method_step?).to eq(true)
        end
      end
    end

    describe "#result_step?" do
      context "when `step` is NOT method step" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Standard::Config

              step first_step
            end
          end
        end

        it "returns `false`" do
          expect(step.result_step?).to eq(false)
        end
      end

      context "when `step` is method step" do
        context "when `step` method is NOT `:result`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              step :foo

              def foo
                success
              end
            end
          end

          it "returns `false`" do
            expect(step.result_step?).to eq(false)
          end
        end

        context "when `step` method is `:result`" do
          let(:service_class) do
            Class.new do
              include ConvenientService::Standard::Config

              step :result

              def result
                success
              end
            end
          end

          it "returns `true`" do
            expect(step.result_step?).to eq(true)
          end
        end
      end
    end

    describe "#method_result" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

          step :result

          def result
            success
          end
        end
      end

      specify do
        expect { step.method_result }
          .to delegate_to(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Commands::CalculateMethodResult, :call)
          .with_arguments(step: step)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
