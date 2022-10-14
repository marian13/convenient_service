# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Object do
  include ConvenientService::RSpec::Matchers::DelegateTo

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
