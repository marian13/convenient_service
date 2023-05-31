# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:first_step) do
    Class.new do
      include ConvenientService::Configs::Standard

      def result
        success
      end
    end
  end

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(first_step) do |first_step|
        include ConvenientService::Configs::Standard

        step first_step
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
    describe "#try?" do
      specify do
        expect { step_instance.try? }
          .to delegate_to(step_instance.internals.cache, :read)
          .with_arguments(:try)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step_instance.try? }
      #     .to delegate_to(ConvenientService::Utils::Bool, :to_bool)
      #     .with_arguments(step_instance.internals.cache[:try])
      #     .and_return_its_value
      # end

      context "when `step` is NOT triable" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step, try: false
            end
          end
        end

        it "returns `false`" do
          expect(step_instance.try?).to eq(false)
        end
      end

      context "when `step` is triable" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step, try: true
            end
          end
        end

        it "returns `true`" do
          expect(step_instance.try?).to eq(true)
        end
      end
    end

    describe "#not_try?" do
      specify do
        expect { step_instance.not_try? }
          .to delegate_to(step_instance.internals.cache, :read)
          .with_arguments(:try)
      end

      ##
      # TODO: Create copies for all utils used inside matchers.
      #
      # specify do
      #   expect { step_instance.not_try? }
      #     .to delegate_to(ConvenientService::Utils::Bool, :to_bool)
      #     .with_arguments(step_instance.internals.cache[:try])
      #     .and_return_its_value
      # end

      context "when `step` is NOT triable" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step, try: false
            end
          end
        end

        it "returns `true`" do
          expect(step_instance.not_try?).to eq(true)
        end
      end

      context "when `step` is triable" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(first_step) do |first_step|
              include ConvenientService::Configs::Standard

              step first_step, try: true
            end
          end
        end

        it "returns `false`" do
          expect(step_instance.not_try?).to eq(false)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
