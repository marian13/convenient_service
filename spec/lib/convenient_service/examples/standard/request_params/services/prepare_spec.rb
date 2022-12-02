# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::Prepare do
  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:result) { described_class.result(request: request, role: role) }

      let(:request) { ConvenientService::Examples::Standard::RequestParams::Entities::Request.new(http_string) }
      let(:role) { ConvenientService::Examples::Standard::RequestParams::Constants::Roles::ADMIN }

      context "when \"happy path\"" do
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

        let(:prepared_params) { {} }

        it "returns success with prepared params" do
          expect(result).to be_success.with_data(params: prepared_params)
        end
      end
    end
  end
end
