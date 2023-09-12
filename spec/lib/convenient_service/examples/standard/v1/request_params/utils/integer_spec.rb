# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::Integer do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".safe_parse" do
      let(:string) { "123" }

      specify do
        expect { described_class.safe_parse(string) }
          .to delegate_to(described_class::SafeParse, :call)
          .with_arguments(string)
          .and_return_its_value
      end
    end
  end
end
