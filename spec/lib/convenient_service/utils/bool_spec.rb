# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Bool, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".to_bool" do
    let(:object) { :foo }

    ##
    # TODO: Create simplified lower-level `delegate_to` for Primitives.
    # https://github.com/marian13/convenient_service/wiki/Docs:-Components
    #
    it "delegates to `ConvenientService::Utils::Bool::ToBool.call`" do
      allow(described_class::ToBool).to receive(:call).with(object).and_call_original

      described_class.to_bool(object)

      expect(described_class::ToBool).to have_received(:call).with(object)
    end

    it "returns `ConvenientService::Utils::Bool::ToBool.call` value" do
      expect(described_class.to_bool(object)).to eq(described_class::ToBool.call(object))
    end
  end
end
