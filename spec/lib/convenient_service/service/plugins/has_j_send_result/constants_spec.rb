# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Constants, type: :standard do
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

    describe "::DEFAULT_ERROR_DATA" do
      it "returns empty hash" do
        expect(described_class::DEFAULT_ERROR_DATA).to eq({})
      end
    end

    describe "::DEFAULT_SUCCESS_MESSAGE" do
      it "returns empty string" do
        expect(described_class::DEFAULT_SUCCESS_MESSAGE).to eq("")
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

    describe "::DEFAULT_SUCCESS_CODE" do
      it "returns `:success`" do
        expect(described_class::DEFAULT_SUCCESS_CODE).to eq(:default_success)
      end
    end

    describe "::DEFAULT_FAILURE_CODE" do
      it "returns `:failure`" do
        expect(described_class::DEFAULT_FAILURE_CODE).to eq(:default_failure)
      end
    end

    describe "::DEFAULT_ERROR_CODE" do
      it "returns `:default_error`" do
        expect(described_class::DEFAULT_ERROR_CODE).to eq(:default_error)
      end
    end
  end
end
