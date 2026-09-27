# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeStrict::Concern, type: :standard do
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

    it { is_expected.to include_module(ConvenientService::Concern) }

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
    describe "#strict?" do
      specify do
        expect { step.strict? }
          .to delegate_to(step.params.extra_kwargs, :[])
          .with_arguments(:strict)
      end

      context "when `strict` option is NOT passed" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class
            end
          end
        end

        it "defaults to `false`" do
          expect(step.strict?).to be(false)
        end
      end

      context "when `strict` option is `nil`" do
        let(:organizer_service_class) do
          Class.new.tap do |klass|
            klass.class_exec(step_service_class) do |step_service_class|
              include ConvenientService::Standard::Config

              step step_service_class, strict: nil
            end
          end
        end

        it "returns `false`" do
          expect(step.strict?).to be(false)
        end
      end

      context "when `strict` option is boolean" do
        context "when `strict` option is `false`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, strict: false
              end
            end
          end

          it "returns `false`" do
            expect(step.strict?).to be(false)
          end
        end

        context "when `strict` option is `true`" do
          let(:organizer_service_class) do
            Class.new.tap do |klass|
              klass.class_exec(step_service_class) do |step_service_class|
                include ConvenientService::Standard::Config

                step step_service_class, strict: true
              end
            end
          end

          it "returns `true`" do
            expect(step.strict?).to be(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
