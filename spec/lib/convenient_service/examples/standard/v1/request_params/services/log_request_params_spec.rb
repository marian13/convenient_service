# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Services::LogRequestParams, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      context "when `LogRequestParams` is successful" do
        subject(:result) { described_class.result(request: request, params: params) }

        let(:request) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::Request.new(http_string: http_string) }

        let(:http_string) do
          <<~TEXT
            POST /rules/1000000.json HTTP/1.1
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

        let(:params) do
          {
            id: "1000000",
            format: "html",
            title: "Avoid error shadowing",
            description: "Check the official User Docs",
            tags: "ruby",
            sources: "https://www.rubyguides.com/2019/07/ruby-instance-variables/"
          }
        end

        let(:message) do
          <<~MESSAGE
            [Thread##{Thread.current.object_id}] [Request##{request.object_id}] [Params]:
            {
              id: #{params[:id].inspect},
              format: #{params[:format].inspect},
              title: #{params[:title].inspect},
              description: #{params[:description].inspect},
              tags: #{params[:tags].inspect},
              sources: #{params[:sources].inspect}
            }
          MESSAGE
        end

        before do
          allow(ConvenientService::Examples::Standard::V1::RequestParams::Entities::Logger).to receive(:log)
        end

        it "returns `success`" do
          expect(result).to be_success.without_data
        end

        it "logs message" do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Entities::Logger, :log)
            .with_arguments(message)
            .without_calling_original
        end

        context "when tag is passed" do
          subject(:result) { described_class.result(request: request, params: params, tag: tag) }

          let(:tag) { "Uncasted" }

          let(:message) do
            <<~MESSAGE
              [Thread##{Thread.current.object_id}] [Request##{request.object_id}] [Params] [#{tag}]:
              {
                id: #{params[:id].inspect},
                format: #{params[:format].inspect},
                title: #{params[:title].inspect},
                description: #{params[:description].inspect},
                tags: #{params[:tags].inspect},
                sources: #{params[:sources].inspect}
              }
            MESSAGE
          end

          it "logs message with tag" do
            expect { result }
              .to delegate_to(ConvenientService::Examples::Standard::V1::RequestParams::Entities::Logger, :log)
              .with_arguments(message)
              .without_calling_original
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
