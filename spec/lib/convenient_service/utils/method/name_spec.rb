# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Method::Name, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".append" do
    let(:method_name) { :foo }
    let(:suffix) { "_without_middlewares" }

    specify do
      expect { described_class.append(method_name, suffix) }
        .to delegate_to(described_class::Append, :call)
        .with_arguments(method_name, suffix)
        .and_return_its_value
    end
  end
end
