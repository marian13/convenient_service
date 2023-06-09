# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanBeTried::Concern do
  include ConvenientService::RSpec::Matchers::CacheItsValue

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
    describe "#try_result?" do
      let(:result) { service.result }

      let(:service) do
        Class.new do
          include ConvenientService::Configs::Standard

          def result
            success
          end

          def try_result
            success
          end
        end
      end

      context "when result is NOT from `try_result` method" do
        let(:result) { service.result }

        it "returns `false`" do
          expect(result.try_result?).to eq(false)
        end
      end

      context "when result is from `try_result` method" do
        let(:result) { service.try_result }

        it "returns `true`" do
          expect(result.try_result?).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
