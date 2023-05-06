# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils do
  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".to_bool" do
      let(:object) { :foo }

      ##
      # TODO: Create Utils copy for Matchers.
      # https://github.com/marian13/convenient_service/wiki/Docs:-Components
      #
      it "delegates to `ConvenientService::Utils::Bool::ToBool.call`" do
        allow(described_class::Bool::ToBool).to receive(:call).with(object).and_call_original

        described_class.to_bool(object)

        expect(described_class::Bool::ToBool).to have_received(:call).with(object)
      end

      it "returns `ConvenientService::Utils::Bool::ToBool.call` value" do
        expect(described_class.to_bool(object)).to eq(described_class::Bool::ToBool.call(object))
      end
    end
  end
end
