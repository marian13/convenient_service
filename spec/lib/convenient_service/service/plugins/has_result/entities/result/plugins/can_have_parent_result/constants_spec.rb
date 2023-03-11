# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::CanHaveParentResult::Constants do
  example_group "constants" do
    describe "::SCOPES" do
      it "returns `1_000`" do
        expect(described_class::PARENTS_LIMIT).to eq(1_000)
      end
    end
  end
end
