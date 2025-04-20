# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

RSpec.describe ConvenientService::Examples::Dry::Gemfile, type: :dry do
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
