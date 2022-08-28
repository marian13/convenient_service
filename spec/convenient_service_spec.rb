require "convenient_service"

RSpec.describe ConvenientService do
  it "has a version number" do
    expect(ConvenientService::VERSION).not_to be_nil
  end
end
