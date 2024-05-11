# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::URL, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".valid?" do
      let(:url) { "https://userdocs.convenientservice.org" }

      specify do
        expect { described_class.valid?(url) }
          .to delegate_to(described_class::Valid, :call)
          .with_arguments(url)
          .and_return_its_value
      end
    end
  end
end
