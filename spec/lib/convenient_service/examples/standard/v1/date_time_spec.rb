# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::DateTime, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature::Configs::Standard) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".safe_parse" do
      let(:string) { "24-02-2022" }
      let(:format) { "%d-%m-%Y" }

      specify do
        expect { described_class.safe_parse(string, format) }
          .to delegate_to(described_class::Services::SafeParse, :result)
          .with_arguments(string: string, format: format)
          .and_return_its_value
      end
    end
  end
end
