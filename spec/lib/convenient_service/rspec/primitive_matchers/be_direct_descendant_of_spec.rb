# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::BeDirectDescendantOf do
  include ConvenientService::RSpec::PrimitiveMatchers::DelegateTo

  example_group "instance methods" do
    let(:klass) do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    let(:instance) { klass.new }

    let(:parent) { String }

    specify do
      expect { instance.be_direct_descendant_of(parent) }
        .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::BeDirectDescendantOf, :new)
        .with_arguments(parent)
    end
  end
end
