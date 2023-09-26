# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Exception do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  it "is `StandardError` descendant" do
    expect(described_class).to be_descendant_of(StandardError)
  end
end
