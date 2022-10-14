# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::String do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".camelize" do
    let(:string) { "foo" }

    specify do
      expect { described_class.camelize(string) }
        .to delegate_to(ConvenientService::Utils::String::Camelize, :call)
        .with_arguments(string)
        .and_return_its_value
    end
  end
end
