# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Castable) }
  end

  example_group "class methods" do
    describe ".cast" do
      let(:other) { :input }
      let(:casted) { described_class.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is `:input`" do
        let(:other) { :input }

        it "returns `:input` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input.new)
        end
      end

      context "when `other` is `:output`" do
        let(:other) { :output }

        it "returns `:output` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Output.new)
        end
      end

      context "when `other` is `\"input\"`" do
        let(:other) { "input" }

        it "returns `input` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input.new)
        end
      end

      context "when `other` is `\"output\"`" do
        let(:other) { "output" }

        it "returns `output` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Output.new)
        end
      end

      context "when `other` is `nil`" do
        let(:other) { nil }

        it "returns `input` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input.new)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
