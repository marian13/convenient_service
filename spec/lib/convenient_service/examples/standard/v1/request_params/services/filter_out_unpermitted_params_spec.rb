# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Services::FilterOutUnpermittedParams do
  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:result) { described_class.result(params: params, permitted_keys: permitted_keys) }

      let(:params) { {id: "1000000", title: "Check the official User Docs", verified: true} }

      context "when params does NOT only permitted keys" do
        let(:permitted_keys) { [:id, :title] }

        it "returns success with `params` without unpermitted keys" do
          expect(result).to be_success.with_data(params: params.slice(*permitted_keys))
        end
      end

      context "when `params` have only permitted keys" do
        let(:permitted_keys) { [:id, :title, :verified] }

        it "returns success with original `params`" do
          expect(result).to be_success.with_data(params: params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
