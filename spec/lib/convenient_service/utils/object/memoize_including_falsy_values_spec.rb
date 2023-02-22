# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object::MemoizeIncludingFalsyValues do
  describe ".call" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    subject(:util_result) { described_class.call(object, ivar_name, &value_block) }

    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:value_block) { proc { false } }

    specify do
      expect { util_result }
        .to delegate_to(ConvenientService::Utils::Object::InstanceVariableFetch, :call)
        .with_arguments(object, ivar_name, &value_block)
        .and_return_its_value
    end
  end
end
