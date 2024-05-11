# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::Array, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".wrap" do
      let(:object) { :foo }

      specify do
        expect { described_class.wrap(object) }
          .to delegate_to(described_class::Wrap, :call)
          .with_arguments(object)
          .and_return_its_value
      end
    end
  end
end
