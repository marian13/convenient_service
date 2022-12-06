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
          tags: ["", "", ""],
          sources: [],
          verified: true
        }
      end

      let(:body_params) { json_body.transform_keys(&:to_sym) }

      let(:merged_params) { path_params.merge(body_params) }

      let(:permitted_params) { merged_params.slice(*(merged_params.keys - [:verified])) }

      before do
        allow(ConvenientService::Examples::Standard::RequestParams::Entities::Logger).to receive(:log).with(anything)
      end

      context "when request is NOT valid to extract params from path" do
        ##
        # Contains invalid path.
        # https://www.w3.org/TR/2011/WD-html5-20110525/urls.html
        #
        let(:path) { "/ru*les/1.json" }
        let(:pattern) { /^\/rules\/(?<id>\d+)\.(?<format>\w+)$/ }

        let(:message) { "Path `#{path}` does NOT match pattern `#{pattern}`." }

        it "fails to extract params from path" do
          expect(result)
            .to be_error
            .of(ConvenientService::Examples::Standard::RequestParams::Services::ExtractParamsFromPath)
            .with_message(message)
        end
      end

      context "when request is NOT valid to extract params from body" do
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

        it "fails to extract params from body" do
          expect(result)
            .to be_error
            .of(ConvenientService::Examples::Standard::RequestParams::Services::ExtractParamsFromBody)
            .with_message(message)
        end
      end

      context "when request is valid to extract params from both path and body" do
        it "merges params extracted from path and body" do
          ##
          # TODO: Introduce `delegate_to_service` to hide `commit_config!`.
          #
          ConvenientService::Examples::Standard::RequestParams::Services::MergeParams.commit_config!

          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::RequestParams::Services::MergeParams, :result)
            .with_arguments(params_from_path: path_params, params_from_body: body_params)
        end

        it "logs merged params from path and body with \"Uncasted\" tag" do
          ##
          # TODO: Introduce `delegate_to_service` to hide `commit_config!`.
          #
          ConvenientService::Examples::Standard::RequestParams::Services::LogRequestParams.commit_config!

          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::RequestParams::Services::LogRequestParams, :result)
            .with_arguments(request: request, params: merged_params, tag: "Uncasted")
        end

        it "filters out unpermitted keys" do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::RequestParams::Services::FilterOutUnpermittedParams, :result)
            .with_arguments(params: merged_params, permitted_keys: [:id, :format, :title, :description, :tags, :sources])
        end

        it "applies default value" do
          # byebug

          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::RequestParams::Services::ApplyDefaultParamValues, :result)
            .with_arguments(params: permitted_params, defaults: {tags: [], sources: []})
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
