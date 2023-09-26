# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Results::BeNotFailure do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  specify do
    expect { be_not_failure }
      .to delegate_to(ConvenientService::RSpec::Matchers::Classes::Results::BeNotFailure, :new)
      .without_arguments
      .and_return_its_value
  end
end
