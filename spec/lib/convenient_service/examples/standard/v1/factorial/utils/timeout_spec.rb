# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::V1::Factorial::Utils::Timeout do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".with_timeout" do
      let(:seconds) { 5 }
      let(:block) { proc { :foo } }

      specify do
        expect { described_class.with_timeout(seconds, &block) }
          .to delegate_to(described_class::WithTimeout, :call)
          .with_arguments(seconds, &block)
          .and_return_its_value
      end
    end
  end
end
