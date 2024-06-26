# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Class, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".display_name" do
    let(:klass) { Class.new }

    specify do
      expect { described_class.display_name(klass) }
        .to delegate_to(described_class::DisplayName, :call)
        .with_arguments(klass)
        .and_return_its_value
    end
  end
end
