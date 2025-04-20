# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object::ResolveType, type: :standard do
  describe ".call" do
    let(:result) { described_class.call(object) }

    context "when `object` is module" do
      let(:object) { Kernel }

      it "returns `module` string" do
        expect(result).to eq("module")
      end
    end

    context "when `object` is class" do
      let(:object) { Array }

      it "returns `class` string" do
        expect(result).to eq("class")
      end
    end

    context "when `object` is neither module nor class" do
      let(:object) { "foo" }

      it "returns `instance` string" do
        expect(result).to eq("instance")
      end
    end
  end
end
