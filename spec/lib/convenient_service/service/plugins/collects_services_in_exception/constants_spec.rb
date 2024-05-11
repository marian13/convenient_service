# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CollectsServicesInException::Constants, type: :standard do
  example_group "constants" do
    describe "DEFAULT_MAX_SERVICES_SIZE" do
      it "returns `1_000`" do
        expect(described_class::DEFAULT_MAX_SERVICES_SIZE).to eq(1_000)
      end
    end
  end
end
