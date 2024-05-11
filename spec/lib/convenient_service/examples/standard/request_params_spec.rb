# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Feature::Configs::Standard) }
  end

  example_group "class methods" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    describe ".prepare" do
      subject(:entry) { described_class.prepare(request) }

      let(:http_string) do
        <<~TEXT
          POST /rules/1.json HTTP/1.1
          User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
          Host: code-review.com
          Content-Type: application/json; charset=utf-8
          Content-Length: length
          Accept-Language: en-us
          Accept-Encoding: gzip, deflate
          Connection: Keep-Alive

          {title:"",description:"",tags:["","",""]}
        TEXT
      end

      let(:request) { described_class::Entities::Request.new(http_string: http_string) }

      specify do
        expect { entry }
          .to delegate_to(described_class::Services::Prepare, :result)
          .with_arguments(request: request)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
