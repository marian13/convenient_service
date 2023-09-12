# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::URL do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".valid?" do
      let(:url) { "https://marian13.github.io/convenient_service_docs" }

      specify do
        expect { described_class.valid?(url) }
          .to delegate_to(described_class::Valid, :call)
          .with_arguments(url)
          .and_return_its_value
      end
    end
  end
end
