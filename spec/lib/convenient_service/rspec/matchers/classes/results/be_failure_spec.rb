# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::BeFailure, type: :standard do
  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Classes::Results::Base) }
  end

  example_group "instance methods" do
    let(:matcher) { described_class.new }

    describe "#statuses" do
      it "returns statuses" do
        expect(matcher.statuses).to eq([ConvenientService::Service::Plugins::HasJSendResult::Constants::FAILURE_STATUS])
      end
    end
  end
end
