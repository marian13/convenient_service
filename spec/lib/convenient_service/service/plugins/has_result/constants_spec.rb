# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Constants do
  example_group "constants" do
    describe "::SUCCESS_STATUS" do
      it "returns `:success`" do
        expect(described_class::SUCCESS_STATUS).to eq(:success)
      end
    end

    describe "::FAILURE_STATUS" do
      it "returns `:failure`" do
        expect(described_class::FAILURE_STATUS).to eq(:failure)
      end
    end

    describe "::ERROR_STATUS" do
      it "returns `:error`" do
        expect(described_class::ERROR_STATUS).to eq(:error)
      end
    end

    describe "::DEFAULT_SUCCESS_DATA" do
      it "returns empty hash" do
        expect(described_class::DEFAULT_SUCCESS_DATA).to eq({})
      end
    end

    describe "::DEFAULT_FAILURE_DATA" do
      it "returns empty hash" do
        expect(described_class::DEFAULT_FAILURE_DATA).to eq({})
      end
    end

    describe "::ERROR_DATA" do
      it "returns empty hash" do
        expect(described_class::ERROR_DATA).to eq({})
      end
    end

    describe "::SUCCESS_MESSAGE" do
      it "returns empty string" do
        expect(described_class::SUCCESS_MESSAGE).to eq("")
      end
    end

    describe "::DEFAULT_FAILURE_MESSAGE" do
      it "returns empty string" do
        expect(described_class::DEFAULT_FAILURE_MESSAGE).to eq("")
      end
    end

    describe "::DEFAULT_ERROR_MESSAGE" do
      it "returns empty string" do
        expect(described_class::DEFAULT_ERROR_MESSAGE).to eq("")
      end
    end

    describe "::SUCCESS_CODE" do
      it "returns `:success`" do
        expect(described_class::SUCCESS_CODE).to eq(:success)
      end
    end

    describe "::FAILURE_CODE" do
      it "returns `:failure`" do
        expect(described_class::FAILURE_CODE).to eq(:failure)
      end
    end

    describe "::DEFAULT_ERROR_CODE" do
      it "returns `:default_error`" do
        expect(described_class::DEFAULT_ERROR_CODE).to eq(:default_error)
      end
    end
  end
end
