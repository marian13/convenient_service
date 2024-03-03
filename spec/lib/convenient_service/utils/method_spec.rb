# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Method do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".defined?" do
    let(:method) { :foo }
    let(:klass) { Class.new }

    specify do
      expect { described_class.defined?(method, klass) }
        .to delegate_to(described_class::Defined, :call)
        .with_arguments(method, klass)
        .and_return_its_value
    end
  end
end
