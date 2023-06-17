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

    describe ".memoize_including_falsy_values" do
      let(:object) { Object.new }
      let(:ivar_name) { :@foo }
      let(:value_block) { proc { false } }

      specify do
        expect { described_class.memoize_including_falsy_values(object, ivar_name, &value_block) }
          .to delegate_to(ConvenientService::Utils::Object::MemoizeIncludingFalsyValues, :call)
          .with_arguments(object, ivar_name, &value_block)
          .and_return_its_value
      end
    end
  end
end
