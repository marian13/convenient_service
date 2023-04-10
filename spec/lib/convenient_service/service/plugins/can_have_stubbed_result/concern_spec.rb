# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveStubbedResult::Concern do
  include ConvenientService::RSpec::Matchers::CacheItsValue

  let(:service_class) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end

  example_group "class methods" do
    describe ".stubbed_results" do
      context "when RSpec current example is NOT set" do
        before do
          allow(ConvenientService::Support::Gems::RSpec).to receive(:current_example).and_return(nil)
        end

        it "returns empty cache" do
          expect(service_class.stubbed_results).to eq(ConvenientService::Support::Cache.create(backend: :thread_safe_array))
        end
      end

      context "when RSpec current example is set" do
        it "returns cache scoped by self" do
          expect(service_class.stubbed_results).to eq(ConvenientService::Support::Cache.create(backend: :thread_safe_array).scope(service_class))
        end

        specify { expect { service_class.stubbed_results }.to cache_its_value }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
