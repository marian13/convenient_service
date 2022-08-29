# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code::ClassMethods do
  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.cast(other) }

      context "when `other' is NOT castable" do
        let(:other) { nil }

        it "returns `nil'" do
          expect(casted).to be_nil
        end
      end

      context "when `other' is symbol" do
        let(:other) { :foo }
        let(:code) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.new(value: other) }

        it "returns that symbol casted to code" do
          expect(casted).to eq(code)
        end
      end

      context "when `other' is string" do
        let(:other) { "foo" }
        let(:code) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.new(value: other.to_sym) }

        it "returns that string casted to code" do
          expect(casted).to eq(code)
        end
      end

      context "when `other' is code" do
        let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.new(value: :foo) }
        let(:code) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Code.new(value: other.value) }

        it "returns copy of `other'" do
          expect(casted).to eq(code)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
