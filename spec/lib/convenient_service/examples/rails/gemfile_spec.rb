# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

RSpec.describe ConvenientService::Examples::Rails::Gemfile, type: :rails do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature::Configs::Standard) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".format" do
      subject(:entry) { described_class.format(path) }

      let(:file) { Tempfile.new }
      let(:path) { file.path }

      specify do
        expect { entry }
          .to delegate_to(described_class::Services::Format, :result)
          .with_arguments(path: path)
          .and_return_its_value
      end
    end
  end
end
