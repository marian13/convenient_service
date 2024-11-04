# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeFromFallback::Concern, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
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
    let(:service) do
      Class.new do
        include ConvenientService::Standard::Config

        def result
          success
        end

        def fallback_failure_result
          success
        end

        def fallback_error_result
          success
        end

        def fallback_result
          success
        end
      end
    end

    describe "#fallback_failure_result?" do
      context "when result is from `result` method" do
        let(:result) { service.result }

        it "returns `false`" do
          expect(result.fallback_failure_result?).to eq(false)
        end
      end

      context "when result is from `fallback_failure_result` method" do
        let(:result) { service.fallback_failure_result }

        it "returns `true`" do
          expect(result.fallback_failure_result?).to eq(true)
        end
      end

      context "when result is from `fallback_error_result` method" do
        let(:result) { service.fallback_error_result }

        it "returns `false`" do
          expect(result.fallback_failure_result?).to eq(false)
        end
      end

      context "when result is from `fallback_result` method" do
        let(:result) { service.fallback_result }

        it "returns `false`" do
          expect(result.fallback_failure_result?).to eq(false)
        end
      end
    end

    describe "#fallback_error_result?" do
      context "when result is from `result` method" do
        let(:result) { service.result }

        it "returns `false`" do
          expect(result.fallback_error_result?).to eq(false)
        end
      end

      context "when result is from `fallback_failure_result` method" do
        let(:result) { service.fallback_failure_result }

        it "returns `false`" do
          expect(result.fallback_error_result?).to eq(false)
        end
      end

      context "when result is from `fallback_error_result` method" do
        let(:result) { service.fallback_error_result }

        it "returns `true`" do
          expect(result.fallback_error_result?).to eq(true)
        end
      end

      context "when result is from `fallback_result` method" do
        let(:result) { service.fallback_result }

        it "returns `false`" do
          expect(result.fallback_error_result?).to eq(false)
        end
      end
    end

    describe "#fallback_result?" do
      context "when result is from `result` method" do
        let(:result) { service.result }

        it "returns `false`" do
          expect(result.fallback_result?).to eq(false)
        end
      end

      context "when result is from `fallback_failure_result` method" do
        let(:result) { service.fallback_failure_result }

        it "returns `false`" do
          expect(result.fallback_result?).to eq(false)
        end
      end

      context "when result is from `fallback_error_result` method" do
        let(:result) { service.fallback_error_result }

        it "returns `false`" do
          expect(result.fallback_result?).to eq(false)
        end
      end

      context "when result is from `fallback_result` method" do
        let(:result) { service.fallback_result }

        it "returns `true`" do
          expect(result.fallback_result?).to eq(true)
        end
      end
    end

    describe "#fallback?" do
      context "when result is from `result` method" do
        let(:result) { service.result }

        it "returns `false`" do
          expect(result.fallback?).to eq(false)
        end
      end

      context "when result is from `fallback_failure_result` method" do
        let(:result) { service.fallback_failure_result }

        it "returns `true`" do
          expect(result.fallback?).to eq(true)
        end
      end

      context "when result is from `fallback_error_result` method" do
        let(:result) { service.fallback_error_result }

        it "returns `true`" do
          expect(result.fallback?).to eq(true)
        end
      end

      context "when result is from `fallback_result` method" do
        let(:result) { service.fallback_result }

        it "returns `true`" do
          expect(result.fallback?).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
