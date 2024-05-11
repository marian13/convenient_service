# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Utils::Object, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".blank?" do
      let(:object) { [] }

      specify do
        expect { described_class.blank?(object) }
          .to delegate_to(described_class::Blank, :call)
          .with_arguments(object)
          .and_return_its_value
      end
    end

    describe ".present?" do
      let(:object) { [] }

      specify do
        expect { described_class.present?(object) }
          .to delegate_to(described_class::Present, :call)
          .with_arguments(object)
          .and_return_its_value
      end
    end
  end
end
