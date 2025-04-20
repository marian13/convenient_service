# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::FilterOutUnpermittedParams, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(params: params, permitted_keys: permitted_keys) }

      let(:params) { {id: "1000000", title: "Check the official User Docs", verified: true} }

      context "when `FilterOutUnpermittedParams` is successful" do
        context "when `params` do NOT have only permitted keys" do
          let(:permitted_keys) { [:id, :title] }

          it "returns `success` with `params` without unpermitted keys" do
            expect(result).to be_success.with_data(params: params.slice(*permitted_keys))
          end
        end

        context "when `params` have only permitted keys" do
          let(:permitted_keys) { [:id, :title, :verified] }

          it "returns `success` with original `params`" do
            expect(result).to be_success.with_data(params: params)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
