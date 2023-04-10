# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::Factorial do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".calculate" do
      let(:number) { 10 }

      specify do
        expect { described_class.calculate(number) }
          .to delegate_to(described_class::Services::Calculate, :result)
          .with_arguments(number: number)
          .and_return_its_value
      end
    end
  end
end
