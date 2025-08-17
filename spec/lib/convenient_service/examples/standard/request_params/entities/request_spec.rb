# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Entities::Request, type: :standard do
  let(:request) { described_class.new(http_string: http_string) }

  let(:http_string) do
    <<~TEXT
      POST /rules/1000000.json HTTP/1.1
      User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36
      Host: code-review.com
      Content-Type: application/json; charset=utf-8
      Content-Length: 134
      Accept-Language: en-us
      Accept-Encoding: gzip, deflate
      Connection: Keep-Alive

      {"title":"Avoid error shadowing","description":"Check the official User Docs","tags":["error-shadowing"]}
    TEXT
  end

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { request }

    it { is_expected.to have_attr_reader(:http_string) }
  end

  example_group "instance methods" do
    describe "#to_s" do
      it "returns `http_string`" do
        expect(request.to_s).to eq(http_string)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
