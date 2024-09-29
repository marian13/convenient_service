# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Configs::Essential, type: :standard do
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

      specify { expect(feature_class).to include_module(ConvenientService::Core) }

      example_group "feature" do
        example_group "concerns" do
          let(:concerns) do
            [
              ConvenientService::Feature::Plugins::CanHaveEntries::Concern,
              ConvenientService::Common::Plugins::HasInstanceProxy::Concern
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
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
