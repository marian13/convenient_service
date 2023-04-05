# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Concern::ClassMethods do
  example_group "class methods" do
    describe ".cast" do
      let(:casted) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.cast(other) }

      context "when `other` is NOT castable" do
        let(:other) { nil }

        it "returns nil" do
          expect(casted).to be_nil
        end
      end

      context "when `other` is symbol" do
        let(:other) { :foo }
        let(:status) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: other) }

        it "returns that symbol casted to status" do
          expect(casted).to eq(status)
        end
      end

      context "when `other` is string" do
        let(:other) { "foo" }
        let(:status) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: other.to_sym) }

        it "returns that string casted to status" do
          expect(casted).to eq(status)
        end
      end

      context "when `other` is status" do
        let(:other) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: :foo) }
        let(:status) { ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.new(value: other.value) }

        it "returns copy of `other`" do
          expect(casted).to eq(status)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
