# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Configs::RSpec, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:feature_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(feature_class).to include_module(ConvenientService::Feature::Configs::Essential) }

      example_group "feature" do
        example_group "concerns" do
          it "adds `ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Concern` to feature concerns" do
            expect(feature_class.concerns.to_a.last).to eq(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Concern)
          end
        end

        example_group "#entry middlewares" do
          it "prepends `ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Middleware` to feature middlewares for `#entry`" do
            expect(feature_class.middlewares(:entry).to_a.first).to eq(ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Middleware)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
