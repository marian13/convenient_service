# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_service_class) do
    Class.new do
      include ConvenientService::Configs::Standard

      ##
      # NOTE: Used by "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer`" specs.
      #
      def self.name
        "StepService"
      end

      def result
        success
      end

      def try_result
        success
      end
    end
  end

  let(:organizer_service_class) do
    Class.new.tap do |klass|
      klass.class_exec(step_service_class) do |step_service_class|
        include ConvenientService::Configs::Standard

        step step_service_class
      end
    end
  end

  let(:organizer_service_instance) { organizer_service_class.new }

  let(:service) { step_service_class }
  let(:organizer) { organizer_service_instance }
  let(:step) { organizer_service_instance.steps.first }

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
    describe "#try?" do
      specify do
        expect { step.try? }
          .to delegate_to(step.internals.cache, :read)
          .with_arguments(:try)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step.try? }
      #     .to delegate_to(ConvenientService::Utils::Bool, :to_bool)
      #     .with_arguments(step.internals.cache[:try])
      #     .and_return_its_value
      # end

      context "when `try` option is NOT passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.try?).to eq(false)
        end
      end

      context "when `try` option is `false`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, try: false
            end
          end
        end

        it "returns `false`" do
          expect(step.try?).to eq(false)
        end
      end

      context "when `try` option is `true`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, try: true
            end
          end
        end

        it "returns `true`" do
          expect(step.try?).to eq(true)
        end
      end
    end

    describe "#not_try?" do
      specify do
        expect { step.not_try? }
          .to delegate_to(step.internals.cache, :read)
          .with_arguments(:try)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step.not_try? }
      #     .to delegate_to(ConvenientService::Utils::Bool, :to_bool)
      #     .with_arguments(step.internals.cache[:try])
      #     .and_return_its_value
      # end

      context "when `try` option is NOT passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class
            end
          end
        end

        it "defaults to `true`" do
          expect(step.not_try?).to eq(true)
        end
      end

      context "when `try` option is `false`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, try: false
            end
          end
        end

        it "returns `true`" do
          expect(step.not_try?).to eq(true)
        end
      end

      context "when `try` option is `true`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, try: true
            end
          end
        end

        it "returns `false`" do
          expect(step.not_try?).to eq(false)
        end
      end
    end

    describe "#original_try_result" do
      context "when `organizer` is NOT set" do
        let(:message) do
          <<~TEXT
            Step `#{step.printable_service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer`" do
          expect { step.copy(overrides: {kwargs: {organizer: nil}}).original_try_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          service.commit_config!

          expect { step.original_try_result }
            .to delegate_to(service, :try_result)
            .with_arguments(**step.input_values)
            .and_return_its_value
        end
      end
    end

    describe "#try_result" do
      context "when `organizer` is NOT set" do
        let(:message) do
          <<~TEXT
            Step `#{step.printable_service}` has not assigned organizer.

            Did you forget to set it?
          TEXT
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer`" do
          expect { step.copy(overrides: {kwargs: {organizer: nil}}).try_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Errors::StepHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          expect { step.try_result }
            .to delegate_to(step.original_try_result, :copy)
            .with_arguments(overrides: {kwargs: {step: step, service: organizer}})
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
