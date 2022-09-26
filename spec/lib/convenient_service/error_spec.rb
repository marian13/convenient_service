# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Error do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  it "is `StandardError` descendant" do
    expect(described_class).to be_descendant_of(StandardError)
  end
end
