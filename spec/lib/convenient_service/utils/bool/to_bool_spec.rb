# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Bool::ToBool, type: :standard do
  describe "#call" do
    subject(:result) { described_class.call(object) }

    context "when object is falsey" do
      let(:object) { nil }

      it "returns false" do
        expect(result).to be(false)
      end
    end

    context "when object is truthy" do
      let(:object) { 42 }

      it "returns true" do
        expect(result).to be(true)
      end
    end
  end
end
