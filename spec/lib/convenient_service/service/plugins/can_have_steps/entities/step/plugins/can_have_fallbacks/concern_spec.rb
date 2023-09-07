# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_service_class) do
    Class.new do
      include ConvenientService::Configs::Standard

      ##
      # @internal
      #   NOTE: Used by "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions::StepHasNoOrganizer`" specs.
      #
      def self.name
        "StepService"
      end

      def initialize(foo:)
        @foo = foo
      end

      def result
        success
      end

      def fallback_failure_result
        success
      end

      def fallback_error_result
        success
      end
    end
  end

  let(:organizer_service_class) do
    Class.new.tap do |klass|
      klass.class_exec(step_service_class) do |step_service_class|
        include ConvenientService::Configs::Standard

        step step_service_class, in: :foo

        def foo
          success
        end
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
    describe "#fallback_failure_step?" do
      specify do
        expect { step.fallback_failure_step? }
          .to delegate_to(step.params.extra_kwargs, :[])
          .with_arguments(:fallback)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step.fallback_step? }
      #     .to delegate_to(ConvenientService::Utils, :to_bool)
      #     .with_arguments(step.params.extra_kwargs[:fallback])
      #     .and_return_its_value
      # end

      context "when `fallback` option is NOT passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.fallback_failure_step?).to eq(false)
        end
      end

      context "when `fallback` option is `nil`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, fallback: nil
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_failure_step?).to eq(false)
        end
      end

      context "when `fallback` option is boolean" do
        context "when `fallback` option is `false`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: false
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to eq(false)
          end
        end

        context "when `fallback` option is `true`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: true
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to eq(false)
          end
        end
      end

      context "when `fallback` option is symbol" do
        context "when `fallback` option is NOT `:failure`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: :error
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to eq(false)
          end
        end

        context "when `fallback` option is `:failure`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: :failure
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_failure_step?).to eq(true)
          end
        end
      end

      context "when `fallback` option is array" do
        context "when `fallback` option is empty array" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: []
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to eq(false)
          end
        end

        context "when `fallback` option is array without `:failure` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: [:error]
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to eq(false)
          end
        end

        context "when `fallback` option is array with `:failure` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: [:failure]
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_failure_step?).to eq(true)
          end
        end
      end
    end

    describe "#fallback_error_step?" do
      specify do
        expect { step.fallback_error_step? }
          .to delegate_to(step.params.extra_kwargs, :[])
          .with_arguments(:fallback)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step.fallback_step? }
      #     .to delegate_to(ConvenientService::Utils, :to_bool)
      #     .with_arguments(step.params.extra_kwargs[:fallback])
      #     .and_return_its_value
      # end

      context "when `fallback` option is NOT passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.fallback_error_step?).to eq(false)
        end
      end

      context "when `fallback` option is `nil`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, fallback: nil
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_error_step?).to eq(false)
        end
      end

      context "when `fallback` option is boolean" do
        context "when `fallback` option is `false`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: false
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to eq(false)
          end
        end

        context "when `fallback` option is `true`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: true
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_error_step?).to eq(true)
          end
        end
      end

      context "when `fallback` option is symbol" do
        context "when `fallback` option is NOT `:error`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: :failure
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to eq(false)
          end
        end

        context "when `fallback` option is `:error`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: :error
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_error_step?).to eq(true)
          end
        end
      end

      context "when `fallback` option is array" do
        context "when `fallback` option is empty array" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: []
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to eq(false)
          end
        end

        context "when `fallback` option is array without `:error` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: [:failure]
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to eq(false)
          end
        end

        context "when `fallback` option is array with `:error` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Configs::Standard

                step step_service_class, fallback: [:error]
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_error_step?).to eq(true)
          end
        end
      end
    end

    describe "#fallback_step?" do
      context "when step neither fallback failure nor fallback error step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, fallback: []
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_step?).to eq(false)
        end
      end

      context "when step is fallback failure step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, fallback: [:failure]
            end
          end
        end

        it "returns `true`" do
          expect(step.fallback_step?).to eq(true)
        end
      end

      context "when step is fallback error step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Configs::Standard

              step step_service_class, fallback: [:error]
            end
          end
        end

        it "returns `true`" do
          expect(step.fallback_step?).to eq(true)
        end
      end
    end

    describe "#service_fallback_failure_result" do
      context "when `organizer` is NOT set" do
        let(:message) do
          <<~TEXT
            Organizer for method `:foo` is NOT assigned yet.

            Did you forget to set it?
          TEXT
        end

        it "returns `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
          expect { step.copy(overrides: {kwargs: {organizer: nil}}).service_fallback_failure_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          service.commit_config!

          expect { step.service_fallback_failure_result }
            .to delegate_to(step.service.klass, :fallback_failure_result)
            .with_arguments(**step.input_values)
            .and_return_its_value
        end
      end
    end

    describe "#fallback_failure_result" do
      context "when `organizer` is NOT set" do
        let(:message) do
          <<~TEXT
            Organizer for method `:foo` is NOT assigned yet.

            Did you forget to set it?
          TEXT
        end

        it "returns `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
          expect { step.copy(overrides: {kwargs: {organizer: nil}}).fallback_failure_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          expect { step.fallback_failure_result }
            .to delegate_to(step.service_fallback_failure_result, :copy)
            .with_arguments(overrides: {kwargs: {step: step, service: organizer}})
            .and_return_its_value
        end
      end
    end

    describe "#service_fallback_error_result" do
      context "when `organizer` is NOT set" do
        let(:message) do
          <<~TEXT
            Organizer for method `:foo` is NOT assigned yet.

            Did you forget to set it?
          TEXT
        end

        it "returns `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
          expect { step.copy(overrides: {kwargs: {organizer: nil}}).service_fallback_error_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          service.commit_config!

          expect { step.service_fallback_error_result }
            .to delegate_to(step.service.klass, :fallback_error_result)
            .with_arguments(**step.input_values)
            .and_return_its_value
        end
      end
    end

    describe "#fallback_error_result" do
      context "when `organizer` is NOT set" do
        let(:message) do
          <<~TEXT
            Organizer for method `:foo` is NOT assigned yet.

            Did you forget to set it?
          TEXT
        end

        it "returns `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer`" do
          expect { step.copy(overrides: {kwargs: {organizer: nil}}).fallback_error_result }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::MethodHasNoOrganizer)
            .with_message(message)
        end
      end

      context "when `organizer` is set" do
        specify do
          expect { step.fallback_error_result }
            .to delegate_to(step.service_fallback_error_result, :copy)
            .with_arguments(overrides: {kwargs: {step: step, service: organizer}})
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
