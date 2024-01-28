# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeNegated::Concern do
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
    include ConvenientService::RSpec::Helpers::IgnoringException

    include ConvenientService::RSpec::Matchers::DelegateTo
    include ConvenientService::RSpec::Matchers::Results

    describe "#result" do
      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(service) do |service|
            include ConvenientService::Service::Configs::Standard

            step service
          end
        end
      end

      let(:service) do
        Class.new do
          include ConvenientService::Service::Configs::Standard

          def result
            success(data: {foo: :bar})
          end
        end
      end

      let(:step) { container.steps.first }

      describe "#negated_step?" do
        context "when step is NOT negated" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(service) do |service|
                include ConvenientService::Service::Configs::Standard

                step service
              end
            end
          end

          it "returns `false`" do
            expect(step.negated_step?).to eq(false)
          end
        end

        context "when step is negated" do
          context "when `not_step` is used" do
            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(service) do |service|
                  include ConvenientService::Service::Configs::Standard

                  not_step service
                end
              end
            end

            it "returns `true`" do
              expect(step.negated_step?).to eq(true)
            end
          end

          context "when `and_not_step` is used" do
            let(:container) do
              Class.new.tap do |klass|
                klass.class_exec(service) do |service|
                  include ConvenientService::Service::Configs::Standard

                  and_not_step service
                end
              end
            end

            it "returns `true`" do
              expect(step.negated_step?).to eq(true)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
