# frozen_string_literal: true

require "spec_helper"

require "convenient_feature"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Commands::IsFeature, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(feature: feature) }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Standard::Config

          def result
            success
          end
        end
      end

      let(:feature) { feature_class.new }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Commands::IsFeatureClass, :call)
          .with_arguments(feature_class: feature.class)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
