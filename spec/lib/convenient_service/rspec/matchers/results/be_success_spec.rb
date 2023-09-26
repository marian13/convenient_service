# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Results::BeSuccess do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  specify do
    expect { be_success }
      .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::BeSuccess, :new)
      .without_arguments
      .and_return_its_value
  end
end
