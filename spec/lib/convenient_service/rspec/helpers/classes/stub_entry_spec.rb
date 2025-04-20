# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Classes::StubEntry, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#call" do
      let(:command_result) { described_class.call(feature_class, entry_name) }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Standard::Config

          entry :main

          def main
            :main_entry_value
          end
        end
      end

      let(:entry_name) { :main }

      specify do
        expect { command_result }
          .to delegate_to(described_class::Entities::StubbedFeature, :new)
          .with_arguments(feature_class: feature_class, entry_name: entry_name)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
