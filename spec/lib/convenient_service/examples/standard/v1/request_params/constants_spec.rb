# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Constants, type: :standard do
  example_group "constants" do
    describe "Tags::EMPTY" do
      it "returns empty string" do
        expect(described_class::Tags::EMPTY).to eq("")
      end
    end
  end
end
