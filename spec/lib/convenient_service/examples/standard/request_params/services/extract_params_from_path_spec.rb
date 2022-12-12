# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::ExtractParamsFromPath do
  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:result) { described_class.result(request: request, pattern: pattern) }

      let(:request) { ConvenientService::Examples::Standard::RequestParams::Entities::Request.new(http_string: http_string) }
      let(:pattern) { /^\/rules\/(?<id>\d+)\.(?<format>\w+)$/ }
      let(:path) { "/rules/#{id}.#{format}" }

      let(:http_string) do
        <<~TEXT
          POST #{path} HTTP/1.1
          User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
          Host: code-review.com
          Content-Type: application/json; charset=utf-8
          Content-Length: 105
          Accept-Language: en-us
          Accept-Encoding: gzip, deflate
          Connection: Keep-Alive

          {"title":"Avoid error shadowing","description":"Check the official User Docs","tags":["error-shadowing"]}
        TEXT
      end

      context "when request is NOT valid for HTTP parsing" do
        let(:http_string) do
          <<~TEXT
            User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
            Host: code-review.com
            Content-Type: application/json; charset=utf-8
            Content-Length: 105
            Accept-Language: en-us
            Accept-Encoding: gzip, deflate
            Connection: Keep-Alive

            {"title":"Avoid error shadowing","description":"Check the official User Docs","tags":["error-shadowing"]}
          TEXT
        end

        let(:error_message) do
          <<~MESSAGE
            Failed to resolve path since request is NOT HTTP parsable.

            Request:
            ---
            #{request}
            ---
          MESSAGE
        end

        it "fails to parse request path" do
          expect(result).to be_error.with_message(error_message)
        end
      end

      context "when request path does NOT match pattern" do
        let(:id) { "abc" }
        let(:format) { "json" }

        let(:error_message) { "Path `#{path}` does NOT match pattern `#{pattern}`." }

        it "fails to parse JSON from request body" do
          expect(result).to be_error.with_message(error_message)
        end
      end

      context "when request path matches pattern" do
        let(:id) { "1000000" }
        let(:format) { "json" }

        let(:params) { {id: id, format: format} }

        it "returns success with params with symbolized keys" do
          expect(result).to be_success.with_data(params: params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
