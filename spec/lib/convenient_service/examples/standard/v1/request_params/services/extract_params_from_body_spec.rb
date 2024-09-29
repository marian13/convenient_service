# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Services::ExtractParamsFromBody, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(request: request) }

      let(:request) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::Request.new(http_string: http_string) }

      context "when `ExtractParamsFromBody` is NOT successful" do
        context "when request is NOT valid for HTTP parsing" do
          let(:http_string) do
            <<~TEXT.gsub("\n", "\r\n")
              POST /rules/1000000.json HTTP/1.1
              User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
              Host: code-review.com
              Content-Type: application/json; charset=utf-8
              Content-Length: 105
              Accept-Language: en-us
              {"title":"Avoid error shadowing","description":"Check the official User Docs","tags":["error-shadowing"]}
              Accept-Encoding: gzip, deflate
              Connection: Keep-Alive

            TEXT
          end

          let(:error_message) do
            <<~MESSAGE
              Failed to resolve body since request is NOT HTTP parsable.

              Request:
              ---
              #{request}
              ---
            MESSAGE
          end

          it "returns `error` with message" do
            expect(result).to be_error.with_message(error_message)
          end
        end

        context "when request body is NOT valid for JSON parsing" do
          let(:http_string) do
            <<~TEXT.gsub("\n", "\r\n")
              POST /rules/1000000.json HTTP/1.1
              User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
              Host: code-review.com
              Content-Type: application/json; charset=utf-8
              Content-Length: #{body.length}
              Accept-Language: en-us
              Accept-Encoding: gzip, deflate
              Connection: Keep-Alive

              #{body}
            TEXT
          end

          let(:body) { "abc" }

          let(:error_message) do
            <<~MESSAGE
              Request body contains invalid json.

              Request:
              ---
              #{request}
              ---
            MESSAGE
          end

          it "returns `error` with message" do
            expect(result).to be_error.with_message(error_message)
          end
        end
      end

      context "when `ExtractParamsFromBody` is successful" do
        let(:http_string) do
          <<~TEXT.gsub("\n", "\r\n")
            POST /rules/1000000.json HTTP/1.1
            User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
            Host: code-review.com
            Content-Type: application/json; charset=utf-8
            Content-Length: #{body.length}
            Accept-Language: en-us
            Accept-Encoding: gzip, deflate
            Connection: Keep-Alive

            #{body}
          TEXT
        end

        let(:body) { "{\"title\":\"Avoid error shadowing\",\"description\":\"Check the official User Docs\",\"tags\":[\"error-shadowing\"]}" }

        let(:params) do
          {
            title: "Avoid error shadowing",
            description: "Check the official User Docs",
            tags: ["error-shadowing"]
          }
        end

        it "returns `success` with params with symbolized keys" do
          expect(result).to be_success.with_data(params: params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
