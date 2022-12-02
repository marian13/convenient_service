# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::Prepare do
  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::DelegateTo
      include ConvenientService::RSpec::Matchers::Results

      subject(:result) { described_class.result(request: request, role: role) }

      let(:request) { ConvenientService::Examples::Standard::RequestParams::Entities::Request.new(http_string) }
      let(:role) { ConvenientService::Examples::Standard::RequestParams::Constants::Roles::ADMIN }

      context "when \"unhappy path\"" do
        context "when fails to extract to params from path" do
          ##
          # https://www.w3.org/TR/2011/WD-html5-20110525/urls.html
          #
          let(:http_string) do
            <<~TEXT
              POST #{path} HTTP/1.1
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

          let(:path) { "/ru*les/1.json" }
          let(:pattern) { /^\/rules\/(?<id>\d+)\.(?<format>\w+)$/ }

          let(:message) { "Path `#{path}` does NOT match pattern `#{pattern}`." }

          it "returns success with prepared params" do
            expect(result)
              .to be_error
              .of(ConvenientService::Examples::Standard::RequestParams::Services::ExtractParamsFromPath)
              .with_message(message)
          end
        end
      end

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
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
