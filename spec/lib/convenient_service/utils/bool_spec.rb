# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Bool do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".to_bool" do
    let(:object) { :foo }

    ##
    # TODO: Create simplified lower-level `delegate_to` for Primitives.
    # https://github.com/marian13/convenient_service/wiki/Docs:-Components
    #
    it "delegates to `ConvenientService::Utils::Bool::ToBool.call`" do
      allow(ConvenientService::Utils::Bool::ToBool).to receive(:call).with(object).and_call_original

      described_class.to_bool(object)

      expect(ConvenientService::Utils::Bool::ToBool).to have_received(:call).with(object)
    end

    it "returns `ConvenientService::Utils::Bool::ToBool.call` value" do
      expect(described_class.to_bool(object)).to eq(ConvenientService::Utils::Bool::ToBool.call(object))
    end
  end
end
