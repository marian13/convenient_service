# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".instance_variable_fetch" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }
    let(:fallback_block) { proc { :bar } }

    specify do
      expect { described_class.instance_variable_fetch(object, ivar_name, &fallback_block) }
        .to delegate_to(ConvenientService::Utils::Object::InstanceVariableFetch, :call)
        .with_arguments(object, ivar_name, &fallback_block)
        .and_return_its_value
    end
  end

  describe ".resolve_type" do
    let(:object) { Kernel }

    specify do
      expect { described_class.resolve_type(object) }
        .to delegate_to(ConvenientService::Utils::Object::ResolveType, :call)
        .with_arguments(object)
        .and_return_its_value
    end
  end
end
