# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type::ClassMethods, type: :standard do
  describe "#cast" do
    let(:type_class) { ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type }

    context "when `other` is NOT castable" do
      let(:other) { 42 }

      it "returns nil" do
        expect(type_class.cast(other)).to be_nil
      end
    end

    context "when `other` is castable" do
      context "when `other` is string" do
        let(:other) { "before" }

        it "returns that string casted to `type`" do
          expect(type_class.cast(other)).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before))
        end

        it "casts that string to symbol" do
          expect(type_class.cast(other).value).to eq(:before)
        end
      end

      context "when `other` is symbol" do
        let(:other) { :before }

        it "returns that string casted to `type`" do
          expect(type_class.cast(other)).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before))
        end
      end

      context "when `other` is `ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type`" do
        let(:other) { ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before) }

        it "returns that type casted to `type`" do
          expect(type_class.cast(other)).to eq(ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Type.new(value: :before))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
