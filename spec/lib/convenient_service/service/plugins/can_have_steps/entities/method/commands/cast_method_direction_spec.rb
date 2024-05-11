# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Commands::CastMethodDirection, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:other) { double }
      let(:options) { {direction: :input} }
      let(:casted) { described_class.call(other: other, options: options) }

      context "when `options[:direction]` is NOT castable" do
        let(:options) { {direction: 42} }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `options[:direction]` is `:input`" do
        let(:options) { {direction: :input} }

        it "returns `:input` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input.new)
        end
      end

      context "when `options[:direction]` is `:output`" do
        let(:options) { {direction: :output} }

        it "returns `:output` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Output.new)
        end
      end

      context "when `options[:direction]` is `input`" do
        let(:options) { {direction: "input"} }

        it "returns `input` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Input.new)
        end
      end

      context "when `options[:direction]` is `output`" do
        let(:options) { {direction: "output"} }

        it "returns `output` casted to method direction" do
          expect(casted).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Directions::Output.new)
        end
      end

      context "when `other` is method" do
        let(:other) { ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method.cast(:foo, direction: :input) }

        it "returns its direction copy" do
          expect(casted).to eq(other.direction.copy)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
