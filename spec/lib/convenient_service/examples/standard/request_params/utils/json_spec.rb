# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Utils::JSON, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".safe_parse" do
      let(:json_string) { "abc" }
      let(:default_value) { "" }

      specify do
        expect { described_class.safe_parse(json_string, default_value: default_value) }
          .to delegate_to(described_class::SafeParse, :call)
          .with_arguments(json_string, default_value: default_value)
          .and_return_its_value
      end

      context "when `default_value` is NOT passed" do
        it "defaults to `nil`" do
          expect { described_class.safe_parse(json_string) }
            .to delegate_to(described_class::SafeParse, :call)
            .with_arguments(json_string, default_value: nil)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
