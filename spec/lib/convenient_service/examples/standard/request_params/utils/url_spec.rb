# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Utils::URL, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".valid?" do
      let(:url) { "https://userdocs.convenientservice.org" }

      specify do
        expect { described_class.valid?(url) }
          .to delegate_to(described_class::Valid, :call)
          .with_arguments(url)
          .and_return_its_value
      end
    end
  end
end
