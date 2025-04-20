# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Feature::Configs::Standard::Commands::IsFeature, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(feature: feature) }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          def main
            :main_entry_value
          end
        end
      end

      let(:feature) { feature_class.new }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Feature::Configs::Standard::Commands::IsFeatureClass, :call)
          .with_arguments(feature_class: feature.class)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
