# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".prepare" do
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

      let(:request) { described_class::Entities::Request.new(http_string) }

      let(:role) { described_class::Constants::Roles::ADMIN }

      specify do
        expect { described_class.prepare(request, role: role) }
          .to delegate_to(described_class::Services::Prepare, :result)
          .with_arguments(request: request, role: role)
          .and_return_its_value
      end

      context "when `role` is NOT passed" do
        it "defaults to `ConvenientService::Examples::Standard::RequestParams::Constants::Roles::GUEST`" do
          expect { described_class.prepare(request) }
            .to delegate_to(described_class::Services::Prepare, :result)
            .with_arguments(request: request, role: described_class::Constants::Roles::GUEST)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
