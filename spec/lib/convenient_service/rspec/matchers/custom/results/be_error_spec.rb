# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::BeError do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Custom::Results::Base) }
  end

  example_group "instance methods" do
    let(:matcher) { described_class.new }

    describe "#statuses" do
      it "returns statuses" do
        expect(matcher.statuses).to eq([ConvenientService::Service::Plugins::HasJSendResult::Constants::ERROR_STATUS])
      end
    end
  end
end
