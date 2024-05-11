# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Services::Prepare, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(request: request) }

      let(:request) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::Request.new(http_string: http_string) }

      ##
      # NOTE: Example for generated `http_string`.
      #
      #   let(:http_string) do
      #     <<~TEXT
      #       POST /rules/1000000.json HTTP/1.1
      #       User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
      #       Host: code-review.com
      #       Content-Type: application/json; charset=utf-8
      #       Content-Length: 134
      #       Accept-Language: en-us
      #       Accept-Encoding: gzip, deflate
      #       Connection: Keep-Alive
      #
      #       {"title":"Avoid error shadowing","description":"Check the official User Docs","tags":["error-shadowing"]}
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
      let(:path_params) { {id: id, format: format} }
      let(:id) { "1000000" }
      let(:format) { "json" }
      let(:body) { JSON.generate(json_body) }

      let(:json_body) do
        {
          title: "Avoid error shadowing",
          description: "Check the official User Docs",
          tags: ["error-shadowing"],
          sources: [],
          verified: true
        }
      end

      let(:body_params) { json_body.transform_keys(&:to_sym) }
      let(:merged_params) { path_params.merge(body_params) }
      let(:permitted_params) { merged_params.slice(*(merged_params.keys - [:verified])) }
      let(:params_with_defaults) { defaults.merge(permitted_params) }
      let(:original_params) { params_with_defaults }

      let(:casted_params) do
        {
          id: ConvenientService::Examples::Standard::V1::RequestParams::Entities::ID.cast(params_with_defaults[:id]),
          format: ConvenientService::Examples::Standard::V1::RequestParams::Entities::Format.cast(params_with_defaults[:format]),
          title: ConvenientService::Examples::Standard::V1::RequestParams::Entities::Title.cast(params_with_defaults[:title]),
          description: ConvenientService::Examples::Standard::V1::RequestParams::Entities::Description.cast(params_with_defaults[:description]),
          tags: params_with_defaults[:tags].map { |tag| ConvenientService::Examples::Standard::V1::RequestParams::Entities::Tag.cast(tag) },
          sources: params_with_defaults[:sources].map { |source| ConvenientService::Examples::Standard::V1::RequestParams::Entities::Source.cast(source) }
        }
      end

      let(:permitted_keys) { [:id, :format, :title, :description, :tags, :sources] }
      let(:defaults) { {format: "json", tags: [], sources: []} }

      before do
        allow(ConvenientService::Examples::Standard::V1::RequestParams::Entities::Logger).to receive(:log).with(anything)
      end

      context "when `Prepare` is NOT successful" do
        context "when `ExtractParamsFromPath` is NOT successful" do
          ##
          # Contains invalid path.
          # https://www.w3.org/TR/2011/WD-html5-20110525/urls.html
          #
          let(:path) { "/ru*les/1.json" }
          let(:pattern) { /^\/rules\/(?<id>\d+)\.(?<format>\w+)$/ }

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_step(ConvenientService::Examples::Standard::V1::RequestParams::Services::ExtractParamsFromPath)
          end
        end

        context "when `ExtractParamsFromBody` is NOT successful" do
          ##
          # Contains unparsable JSON body.
          #
          let(:body) { "abc" }

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_step(ConvenientService::Examples::Standard::V1::RequestParams::Services::ExtractParamsFromBody)
          end
        end

        context "when uncasted params are NOT valid" do
          ##
          # Contains unsupported format, only JSON is available.
          #
          let(:path) { "/rules/1.html" }

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_step(ConvenientService::Examples::Standard::V1::RequestParams::Services::ValidateUncastedParams)
          end
        end

        context "when casted params are NOT valid" do
          before do
            allow(ConvenientService::Examples::Standard::V1::RequestParams::Entities::ID).to receive(:cast).and_return(nil)
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_step(ConvenientService::Examples::Standard::V1::RequestParams::Services::ValidateCastedParams)
          end
        end
      end

      context "when `Prepare` is successful" do
        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Services::MergeParams, :result)
            .with_arguments(params_from_path: path_params, params_from_body: body_params)
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Services::LogRequestParams, :result)
            .with_arguments(request: request, params: merged_params, tag: "Uncasted")
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Services::FilterOutUnpermittedParams, :result)
            .with_arguments(params: merged_params, permitted_keys: permitted_keys)
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Services::ApplyDefaultParamValues, :result)
            .with_arguments(params: permitted_params, defaults: defaults)
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Services::LogRequestParams, :result)
            .with_arguments(request: request, params: casted_params, tag: "Casted")
        end

        it "returns `success` with casted params" do
          expect(result).to be_success.with_data(params: casted_params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
