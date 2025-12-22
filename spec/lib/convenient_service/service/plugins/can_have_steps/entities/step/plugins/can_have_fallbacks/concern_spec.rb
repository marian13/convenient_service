# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanHaveFallbacks::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:step_service_class) do
    Class.new do
      include ConvenientService::Standard::Config

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
        include ConvenientService::Standard::Config

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
              include ConvenientService::Standard::Config

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.fallback_failure_step?).to be(false)
        end
      end

      context "when `fallback` option is `nil`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: nil
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_failure_step?).to be(false)
        end
      end

      context "when `fallback` option is boolean" do
        context "when `fallback` option is `false`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: false
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to be(false)
          end
        end

        context "when `fallback` option is `true`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: true
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to be(false)
          end
        end
      end

      context "when `fallback` option is symbol" do
        context "when `fallback` option is NOT `:failure`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: :error
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to be(false)
          end
        end

        context "when `fallback` option is `:failure`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: :failure
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_failure_step?).to be(true)
          end
        end
      end

      context "when `fallback` option is array" do
        context "when `fallback` option is empty array" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: []
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to be(false)
          end
        end

        context "when `fallback` option is array without `:failure` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: [:error]
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_failure_step?).to be(false)
          end
        end

        context "when `fallback` option is array with `:failure` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: [:failure]
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_failure_step?).to be(true)
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
              include ConvenientService::Standard::Config

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.fallback_error_step?).to be(false)
        end
      end

      context "when `fallback` option is `nil`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: nil
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_error_step?).to be(false)
        end
      end

      context "when `fallback` option is boolean" do
        context "when `fallback` option is `false`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: false
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to be(false)
          end
        end

        context "when `fallback` option is `true`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: true
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to be(false)
          end
        end
      end

      context "when `fallback` option is symbol" do
        context "when `fallback` option is NOT `:error`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: :failure
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to be(false)
          end
        end

        context "when `fallback` option is `:error`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: :error
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_error_step?).to be(true)
          end
        end
      end

      context "when `fallback` option is array" do
        context "when `fallback` option is empty array" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: []
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to be(false)
          end
        end

        context "when `fallback` option is array without `:error` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: [:failure]
              end
            end
          end

          it "returns `false`" do
            expect(step.fallback_error_step?).to be(false)
          end
        end

        context "when `fallback` option is array with `:error` symbol" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, fallback: [:error]
              end
            end
          end

          it "returns `true`" do
            expect(step.fallback_error_step?).to be(true)
          end
        end
      end
    end

    describe "#fallback_true_step?" do
      specify do
        expect { step.fallback_true_step? }
          .to delegate_to(step.params.extra_kwargs, :[])
          .with_arguments(:fallback)
      end

      context "when `fallback` option is NOT passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.fallback_true_step?).to be(false)
        end
      end

      context "when `fallback` option is NOT `true`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: nil
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_true_step?).to be(false)
        end
      end

      context "when `fallback` option is `true`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: true
            end
          end
        end

        it "returns `true`" do
          expect(step.fallback_true_step?).to be(true)
        end
      end
    end

    describe "#fallback_step?" do
      context "when step none of fallback tru, fallback failure or fallback error step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: []
            end
          end
        end

        it "returns `false`" do
          expect(step.fallback_step?).to be(false)
        end
      end

      context "when step is fallback true step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: true
            end
          end
        end

        it "returns `true`" do
          expect(step.fallback_step?).to be(true)
        end
      end

      context "when step is fallback failure step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: [:failure]
            end
          end
        end

        it "returns `true`" do
          expect(step.fallback_step?).to be(true)
        end
      end

      context "when step is fallback error step" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, fallback: [:error]
            end
          end
        end

        it "returns `true`" do
          expect(step.fallback_step?).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
