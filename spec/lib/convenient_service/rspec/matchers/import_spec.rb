# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Import do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:klass) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:klass_instance) { klass.new }
  let(:method) { :foo }

  specify do
    expect { klass_instance.import(method) }
      .to delegate_to(ConvenientService::RSpec::Matchers::Custom::Import, :new)
      .with_arguments(method)
  end
end
