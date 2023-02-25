# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Constants do
  example_group "constants" do
    describe "DEFAULT_MAX_BACKTRACE_SIZE" do
      it "returns `10`" do
        expect(described_class::DEFAULT_MAX_BACKTRACE_SIZE).to eq(10)
      end
    end

    describe "MESSAGE_LINE_PREFIX" do
      it "returns two spaces" do
        expect(described_class::MESSAGE_LINE_PREFIX).to eq("  ")
      end
    end
  end
end
