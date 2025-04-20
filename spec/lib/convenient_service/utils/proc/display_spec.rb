# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Proc::Display, type: :standard do
  describe ".call" do
    subject(:display) { described_class.call(proc) }

    let(:proc) { -> { :foo } }

    it "returns `{ ... }`" do
      expect(display).to eq("{ ... }")
    end
  end
end
