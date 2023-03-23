# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message::Concern::ClassMethods do
  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns `nil`" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:message) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.new(value: other.to_s) }

        it "returns that symbol casted to message" do
          expect(casted).to eq(message)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:message) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.new(value: other) }

        it "returns that string casted to message" do
          expect(casted).to eq(message)
        end
      end

      context "when `other` is message" do
        let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.new(value: "foo") }
        let(:message) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
