# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::HaveAbstractMethod do
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

    let(:method) { :foo }

    specify do
      expect { instance.have_abstract_method(method) }
        .to delegate_to(ConvenientService::RSpec::PrimitiveMatchers::Classes::HaveAbstractMethod, :new)
        .with_arguments(method)
    end
  end
end
