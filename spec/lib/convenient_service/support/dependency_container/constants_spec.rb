# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::DependencyContainer::Constants do
  example_group "constants" do
    describe "::SCOPES" do
      it "returns scopes as array" do
        expect(described_class::SCOPES).to eq([described_class::INSTANCE_SCOPE, described_class::CLASS_SCOPE])
      end
    end

    describe "::INSTANCE_SCOPE" do
      it "returns `:instance`" do
        expect(described_class::INSTANCE_SCOPE).to eq(:instance)
      end
    end

    describe "::CLASS_SCOPE" do
      it "returns `:class`" do
        expect(described_class::CLASS_SCOPE).to eq(:class)
      end
    end

    describe "::DEFAULT_SCOPE" do
      it "returns `ConvenientService::Support::DependencyContainer::Constants::INSTANCE_SCOPE`" do
        expect(described_class::DEFAULT_SCOPE).to eq(ConvenientService::Support::DependencyContainer::Constants::INSTANCE_SCOPE)
      end
    end

    describe "::DEFAULT_PREPEND" do
      it "returns `false`" do
        expect(described_class::DEFAULT_PREPEND).to eq(false)
      end
    end

    describe "::DEFAULT_ALIAS_SLUG" do
      it "returns empty string" do
        expect(described_class::DEFAULT_ALIAS_SLUG).to be_empty
      end
    end

    describe "::DEFAULT_BODY" do
      it "returns `nil`" do
        expect(described_class::DEFAULT_BODY.call).to be_nil
      end
    end
  end
end
