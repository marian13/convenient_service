# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:value) { "foo" }
  let(:reassignemnt) { described_class.new(value) }

  example_group "instance methods" do
    describe "#to_s" do
      it "returns value converted to string" do
        expect(reassignemnt.to_s).to eq(value.to_s)
      end
    end

    describe "#to_sym" do
      it "returns value converted to symbol" do
        expect(reassignemnt.to_sym).to eq(value.to_sym)
      end
    end

    example_group "comparison" do
      describe "#==" do
        context "when results have different classes" do
          let(:other) { "string" }

          it "returns `nil`" do
            expect(reassignemnt == other).to eq(nil)
          end
        end

        context "when other has different value" do
          let(:other) { described_class.new("bar") }

          it "returns `false`" do
            expect(reassignemnt == other).to eq(false)
          end
        end

        context "when other has same value" do
          let(:other) { described_class.new("foo") }

          it "returns `true`" do
            expect(reassignemnt == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
