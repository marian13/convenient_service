# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::ApplyDefaultParamValues do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      context "when `ApplyDefaultParamValues` is successful" do
        subject(:result) { described_class.result(params: params, defaults: defaults) }

        let(:params) { {id: "1000000", title: "Check the official User Docs"} }
        let(:defaults) { {tags: [], sources: []} }

        it "returns `success` with params and defaults" do
          expect(result).to be_success.with_data(params: {id: "1000000", title: "Check the official User Docs", tags: [], sources: []})
        end

        context "when `params` and `defaults` have same keys" do
          let(:params) { {id: "1000000", title: "Check the official User Docs", tags: ["ruby"]} }

          it "takes value from `params`" do
            expect(result).to be_success.with_data(params: {id: "1000000", title: "Check the official User Docs", tags: ["ruby"], sources: []})
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
