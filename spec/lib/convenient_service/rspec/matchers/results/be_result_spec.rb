# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Results::BeResult do
  include ConvenientService::RSpec::Matchers::Results

  specify do
    expect(be_result(:success)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeSuccess.new)
  end

  specify do
    expect(be_result(:failure)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeFailure.new)
  end

  specify do
    expect(be_result(:error)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeError.new)
  end

  specify do
    expect(be_result(:not_success)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeNotSuccess.new)
  end

  specify do
    expect(be_result(:not_failure)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeNotFailure.new)
  end

  specify do
    expect(be_result(:not_error)).to eq(ConvenientService::RSpec::Matchers::Classes::Results::BeNotError.new)
  end
end
