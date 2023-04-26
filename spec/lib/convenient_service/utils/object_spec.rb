# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".instance_variable_delete" do
    let(:object) { Object.new }
    let(:ivar_name) { :@foo }

    specify do
      expect { described_class.instance_variable_delete(object, ivar_name) }
        .to delegate_to(ConvenientService::Utils::Object::InstanceVariableDelete, :call)
        .with_arguments(object, ivar_name)
        .and_return_its_value
    end
  end

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

  describe ".resolve_class" do
    let(:object) { :foo }

    specify do
      expect { described_class.resolve_class(object) }
        .to delegate_to(ConvenientService::Utils::Object::ResolveClass, :call)
        .with_arguments(object)
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
