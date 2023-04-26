# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
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
    let(:service_instance) { service_class.new }

    let(:max_iteration_count) { 10 }
    let(:default) { 42 }
    let(:raise_on_exceedance) { false }
    let(:block) { proc { :foo } }

    describe "#finite_loop" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          concerns do
            use ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Concern
          end

          ##
          # NOTE: `finite_loop` is intentionally private. That's why `finite_loop_public` wrapper is used.
          #
          def finite_loop_public(...)
            finite_loop(...)
          end
        end
      end

      specify do
        expect { service_instance.finite_loop_public(max_iteration_count: max_iteration_count, default: default, raise_on_exceedance: raise_on_exceedance, &block) }
          .to delegate_to(ConvenientService::Support::FiniteLoop, :finite_loop)
          .with_arguments(max_iteration_count: max_iteration_count, default: default, raise_on_exceedance: false, &block)
          .and_return_its_value
      end

      context "when `max_iteration_count` is NOT passed" do
        it "defaults to `ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants::MAX_ITERATION_COUNT`" do
          expect { service_instance.finite_loop_public(default: default, raise_on_exceedance: raise_on_exceedance, &block) }
            .to delegate_to(ConvenientService::Support::FiniteLoop, :finite_loop)
            .with_arguments(max_iteration_count: ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants::MAX_ITERATION_COUNT, default: default, raise_on_exceedance: false, &block)
        end
      end

      context "when `default` is NOT passed" do
        it "defaults to `ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants::FINITE_LOOP_EXCEEDED`" do
          expect { service_instance.finite_loop_public(max_iteration_count: max_iteration_count, raise_on_exceedance: raise_on_exceedance, &block) }
            .to delegate_to(ConvenientService::Support::FiniteLoop, :finite_loop)
            .with_arguments(max_iteration_count: max_iteration_count, default: ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants::FINITE_LOOP_EXCEEDED, raise_on_exceedance: false, &block)
        end
      end

      context "when `raise_on_exceedance` is NOT passed" do
        it "defaults to `false`" do
          expect { service_instance.finite_loop_public(max_iteration_count: max_iteration_count, default: default, &block) }
            .to delegate_to(ConvenientService::Support::FiniteLoop, :finite_loop)
            .with_arguments(max_iteration_count: max_iteration_count, default: default, raise_on_exceedance: false, &block)
        end
      end
    end

    describe "#finite_loop_exceeded" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          concerns do
            use ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Concern
          end

          ##
          # NOTE: `finite_loop_exceeded` is intentionally private. That's why `finite_loop_exceeded_public` wrapper is used.
          #
          def finite_loop_exceeded_public
            finite_loop_exceeded
          end
        end
      end

      it "returns `ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants::FINITE_LOOP_EXCEEDED`" do
        expect(service_instance.finite_loop_exceeded_public).to eq(ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants::FINITE_LOOP_EXCEEDED)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
