# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Bool, type: :standard do
  describe ".to_bool" do
    let(:object) { :foo }

    it "delegates to `ConvenientService::Utils::Bool::ToBool.call`" do
      allow(described_class::ToBool).to receive(:call).with(object).and_call_original

      described_class.to_bool(object)

      expect(described_class::ToBool).to have_received(:call).with(object)
    end

    it "returns `ConvenientService::Utils::Bool::ToBool.call` value" do
      expect(described_class.to_bool(object)).to eq(described_class::ToBool.call(object))
    end
  end
end
