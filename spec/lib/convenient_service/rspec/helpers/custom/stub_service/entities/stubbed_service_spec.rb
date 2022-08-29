# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::Custom::StubService::Entities::StubbedService do
  let(:stubbed_service) { described_class.new(service_class: service_class) }

  let(:service_class) { Class.new }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(RSpec::Matchers) }
    it { is_expected.to include_module(RSpec::Mocks::ExampleMethods) }
  end

  ##
  # TODO: Specs.
  #
end
