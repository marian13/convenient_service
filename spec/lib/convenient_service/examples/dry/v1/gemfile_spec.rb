# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

RSpec.describe ConvenientService::Examples::Dry::V1::Gemfile do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".format" do
      let(:file) { Tempfile.new }
      let(:path) { file.path }

      specify do
        expect { described_class.format(path) }
          .to delegate_to(described_class::Services::Format, :result)
          .with_arguments(path: path)
          .and_return_its_value
      end
    end
  end
end
