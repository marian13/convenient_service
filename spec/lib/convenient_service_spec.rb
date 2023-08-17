# frozen_string_literal: true

require "convenient_service"

RSpec.describe ConvenientService do
  it "has a version number" do
    expect(ConvenientService::VERSION).not_to be_nil
  end

  example_group "class methods" do
    describe ".logger" do
      it "returns logger instance" do
        expect(described_class.logger).to eq(described_class::Logger.instance)
      end
    end
  end
end
