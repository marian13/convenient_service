# frozen_string_literal: true

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

    let(:service_instance) { service_class.new }

    let(:step) { service_instance.steps.first }

    describe "#method" do
      specify do
        expect { step.method }
          .to delegate_to(step.extra_kwargs, :[])
          .with_arguments(:method)
          .and_return_its_value
      end
    end

    describe "#method_step?" do
      context "when `step` does NOT have method" do
        before do
          step.extra_kwargs.delete(:method)
        end

        it "returns `false`" do
          expect(step.method_step?).to eq(false)
        end
      end

      context "when `step` has method" do
        it "returns `true`" do
          expect(step.method_step?).to eq(true)
        end
      end
    end

    describe "#result_step?" do
      context "when `step` does NOT have method" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            step :result

            def result
              success
            end
          end
        end

        before do
          step.extra_kwargs.delete(:method)
        end

        it "returns `false`" do
          expect(step.result_step?).to eq(false)
        end
      end

      context "when `step` has method" do
        context "when that method value is NOT `:result`" do
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

        context "when that method value is `:result`" do
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
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
