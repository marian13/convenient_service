# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::Integer, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".safe_parse" do
      let(:string) { "123" }

      specify do
        expect { described_class.safe_parse(string) }
          .to delegate_to(described_class::SafeParse, :call)
          .with_arguments(string)
          .and_return_its_value
      end
    end
  end
end
