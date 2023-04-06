# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Export do
  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:klass) do
    Class.new.tap do |klass|
      klass.class_exec(described_class) do |mod|
        include mod
      end
    end
  end

  let(:klass_instance) { klass.new }
  let(:method) { :method_name }

  specify do
    expect { klass_instance.export(method) }
      .to delegate_to(ConvenientService::RSpec::Matchers::Custom::Export, :new)
      .with_arguments(method)
  end
end
