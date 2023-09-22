# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeCompleted::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:service_class) do
    Class.new do
      include ConvenientService::Service::Configs::Minimal

      step :foo

      def foo
        success
      end
    end
  end

  let(:service_instance) { service_class.new }

  let(:step_class) { service_class.step_class }
  let(:step_instance) { service_instance.steps.first }

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
    describe "#completed?" do
      specify do
        expect { step_instance.completed? }
          .to delegate_to(step_instance.internals.cache, :read)
          .with_arguments(:completed)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step_instance.completed? }
      #     .to delegate_to(ConvenientService::Utils, :to_bool)
      #     .with_arguments(step_instance.internals.cache[:completed])
      #     .and_return_its_value
      # end

      context "when `step` is NOT completed" do
        it "returns `false`" do
          expect(step_instance.completed?).to eq(false)
        end
      end

      context "when `step` is completed" do
        it "returns `true`" do
          step_instance.mark_as_completed!

          expect(step_instance.completed?).to eq(true)
        end
      end
    end

    describe "#not_completed?" do
      specify do
        expect { step_instance.not_completed? }
          .to delegate_to(step_instance.internals.cache, :read)
          .with_arguments(:completed)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step_instance.not_completed? }
      #     .to delegate_to(ConvenientService::Utils, :to_bool)
      #     .with_arguments(step_instance.internals.cache[:completed])
      #     .and_return_its_value
      # end

      context "when `step` is NOT completed" do
        it "returns `true`" do
          expect(step_instance.not_completed?).to eq(true)
        end
      end

      context "when `step` is completed" do
        it "returns `false`" do
          step_instance.mark_as_completed!

          expect(step_instance.not_completed?).to eq(false)
        end
      end
    end

    describe "#mark_as_completed" do
      specify do
        expect { step_instance.mark_as_completed! }
          .to delegate_to(step_instance.internals.cache, :write)
          .with_arguments(:completed, true)
          .and_return_its_value
      end

      it "returns `true`" do
        expect(step_instance.mark_as_completed!).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
