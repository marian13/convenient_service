# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data::ClassMethods do
  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is hash" do
        let(:other) { {foo: :bar} }
        let(:data) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.new(value: other) }

        it "returns that hash casted to data" do
          expect(casted).to eq(data)
        end

        context "when that hash has string keys" do
          let(:other) { {"foo" => :bar} }
          let(:data) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.new(value: {foo: :bar}) }

          it "converts string keys to symbol keys" do
            expect(casted).to eq(data)
          end
        end
      end

      context "when `other` is data" do
        let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.new(value: {foo: :bar}) }
        let(:data) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Entities::Data.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(data)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
