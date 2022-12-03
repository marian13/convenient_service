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

      ##
      # NOTE: Example for generated `http_string`.
      #
      #   let(:http_string) do
      #     <<~TEXT
      #       POST /rules/1.json HTTP/1.1
      #       User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
      #       Host: code-review.com
      #       Content-Type: application/json; charset=utf-8
      #       Content-Length: 47
      #       Accept-Language: en-us
      #       Accept-Encoding: gzip, deflate
      #       Connection: Keep-Alive
      #
      #       {"title":"","description":"","tags":["","",""]}
      #     TEXT
      #   end
      #
      let(:http_string) do
        <<~TEXT
          POST #{path} HTTP/1.1
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

      let(:path) { "/rules/%{id}.%{format}" % path_params }

      let(:path_params) { {id: "1", format: "json"} }

      let(:body) { JSON.generate(json_body) }

      let(:json_body) do
        {
          title: "",
          description: "",
          tags: ["", "", ""]
        }
      end

      let(:body_params) { json_body.transform_keys(&:to_sym) }

      context "when \"unhappy path\"" do
        context "when fails to extract params from path" do
          ##
          # Contains invalid path.
          # https://www.w3.org/TR/2011/WD-html5-20110525/urls.html
          #
          let(:path) { "/ru*les/1.json" }
          let(:pattern) { /^\/rules\/(?<id>\d+)\.(?<format>\w+)$/ }

          let(:message) { "Path `#{path}` does NOT match pattern `#{pattern}`." }

          it "returns intermediate error" do
            expect(result)
              .to be_error
              .of(ConvenientService::Examples::Standard::RequestParams::Services::ExtractParamsFromPath)
              .with_message(message)
          end
        end

        context "when fails to extract params from body" do
          ##
          # Contains unparsable JSON body.
          #
          let(:body) { "abc" }

          let(:message) do
            <<~MESSAGE
              Request body contains invalid json.

              Request:
              ---
              #{request}
              ---
            MESSAGE
          end

          it "returns intermediate error" do
            expect(result)
              .to be_error
              .of(ConvenientService::Examples::Standard::RequestParams::Services::ExtractParamsFromBody)
              .with_message(message)
          end
        end
      end

      context "when \"happy path\"" do
        let(:prepared_params) { path_params.merge(body_params) }

        it "returns success with prepared params" do
          expect(result).to be_success.with_data(params: prepared_params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
