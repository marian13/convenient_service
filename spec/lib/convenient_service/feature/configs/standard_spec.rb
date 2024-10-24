# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Configs::Standard, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature::Config) }

    context "when included" do
      let(:feature_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      example_group "feature" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Feature::Plugins::CanHaveEntries::Concern,
              ConvenientService::Common::Plugins::HasInstanceProxy::Concern,
              ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Concern
            ]
          end

          it "sets feature concerns" do
            expect(feature_class.concerns.to_a).to eq(concerns)
          end
        end

        example_group ".new middlewares" do
          let(:class_new_middlewares) do
            [
              ConvenientService::Common::Plugins::HasInstanceProxy::Middleware
            ]
          end

          it "sets feature middlewares for `.new`" do
            expect(feature_class.middlewares(:new, scope: :class).to_a).to eq(class_new_middlewares)
          end
        end

        example_group ".trigger middlewares" do
          let(:class_trigger_middlewares) do
            [
              ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware
            ]
          end

          it "sets feature middlewares for `.trigger`" do
            expect(feature_class.middlewares(:trigger, scope: :class).to_a).to eq(class_trigger_middlewares)
          end
        end

        example_group "#trigger middlewares" do
          let(:trigger_middlewares) do
            [
              ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware
            ]
          end

          it "sets feature middlewares for `.trigger`" do
            expect(feature_class.middlewares(:trigger).to_a).to eq(trigger_middlewares)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
