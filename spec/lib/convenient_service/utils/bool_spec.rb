# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Bool do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".to_bool" do
    let(:object) { :foo }

    specify do
      expect { described_class.to_bool(object) }
        .to delegate_to(ConvenientService::Utils::Bool::ToBool, :call)
        .with_arguments(object)
        .and_return_its_value
    end
  end
end
