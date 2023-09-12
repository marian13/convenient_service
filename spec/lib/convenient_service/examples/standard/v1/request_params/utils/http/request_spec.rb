# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::HTTP::Request do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
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

    describe ".parse_body" do
      specify do
        expect { described_class.parse_body(http_string) }
          .to delegate_to(described_class::ParseBody, :call)
          .with_arguments(http_string: http_string)
          .and_return_its_value
      end
    end

    describe ".parse_path" do
      specify do
        expect { described_class.parse_path(http_string) }
          .to delegate_to(described_class::ParsePath, :call)
          .with_arguments(http_string: http_string)
          .and_return_its_value
      end
    end
  end
end
