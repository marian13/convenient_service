# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Feature::Plugins::CanHaveStubbedEntries, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".set_feature_stubbed_entry" do
      let(:feature) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          def main
            :main_entry_value
          end
        end
      end

      let(:entry) { :main }
      let(:arguments) { ConvenientService::Support::Arguments.new(:foo, {foo: :bar}) { :foo } }
      let(:value) { :stub_value }

      specify do
        expect { described_class.set_feature_stubbed_entry(feature, entry, arguments, value) }
          .to delegate_to(described_class::Commands::SetFeatureStubbedEntry, :call)
          .with_arguments(feature: feature, entry: entry, arguments: arguments, value: value)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
