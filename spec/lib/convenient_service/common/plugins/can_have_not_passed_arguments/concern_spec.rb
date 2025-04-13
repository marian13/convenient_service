# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CanHaveNotPassedArguments::Concern, type: :standard do
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

  example_group "class methods" do
    describe "#not_passed" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config.with(:not_passed)

          ##
          # TODO: Missing private methods trigger config commitment, but they are not immediately recalled. Why?
          #
          commit_config!

          ##
          # NOTE: `not_passed` is intentionally private. That's why `not_passed_public` wrapper is used.
          #
          def self.not_passed_public(...)
            not_passed(...)
          end
        end
      end

      it "returns `ConvenientService::Support::NOT_PASSED`" do
        expect(service_class.not_passed_public).to eq(ConvenientService::Support::NOT_PASSED)
      end
    end

    describe "#not_passed?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config.with(:not_passed)

          ##
          # TODO: Missing private methods trigger config commitment, but they are not immediately recalled. Why?
          #
          commit_config!

          ##
          # NOTE: `not_passed` is intentionally private. That's why `not_passed_public` wrapper is used.
          #
          def self.not_passed_public(...)
            not_passed(...)
          end

          ##
          # NOTE: `not_passed?` is intentionally private. That's why `not_passed_public?` wrapper is used.
          #
          def self.not_passed_public?(...)
            not_passed?(...)
          end
        end
      end

      context "when `argument` is NOT `not_passed`" do
        it "returns `false`" do
          expect(service_class.not_passed_public?(42)).to eq(false)
        end
      end

      context "when `argument` is `not_passed`" do
        it "returns `true`" do
          expect(service_class.not_passed_public?(service_class.not_passed_public)).to eq(true)
        end
      end
    end
  end

  example_group "instance methods" do
    let(:service_instance) { service_class.new }

    describe "#not_passed" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config.with(:not_passed)

          ##
          # NOTE: `not_passed` is intentionally private. That's why `not_passed_public` wrapper is used.
          #
          def not_passed_public(...)
            not_passed(...)
          end
        end
      end

      it "returns `ConvenientService::Support::NOT_PASSED`" do
        expect(service_instance.not_passed_public).to eq(ConvenientService::Support::NOT_PASSED)
      end
    end

    describe "#not_passed?" do
      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config.with(:not_passed)

          ##
          # NOTE: `not_passed` is intentionally private. That's why `not_passed_public` wrapper is used.
          #
          def not_passed_public(...)
            not_passed(...)
          end

          ##
          # NOTE: `not_passed?` is intentionally private. That's why `not_passed_public?` wrapper is used.
          #
          def not_passed_public?(...)
            not_passed?(...)
          end
        end
      end

      context "when `argument` is NOT `not_passed`" do
        it "returns `false`" do
          expect(service_instance.not_passed_public?(42)).to eq(false)
        end
      end

      context "when `argument` is `not_passed`" do
        it "returns `true`" do
          expect(service_instance.not_passed_public?(service_instance.not_passed_public)).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
