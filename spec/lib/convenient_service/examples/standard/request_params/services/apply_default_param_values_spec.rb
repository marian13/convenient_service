# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::ApplyDefaultParamValues do
  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:result) { described_class.result(params: params, defaults: defaults) }

      let(:params) { {id: "", title: ""} }
      let(:defaults) { {tags: [], sources: []} }

      it "return success merged params" do
        expect(result).to be_success.with_data(params: {id: "", title: "", tags: [], sources: []})
      end

      context "when both `params` and `defaults` have the same key" do
        let(:params) { {id: "", title: "", tags: [:important]} }

        it "takes value from `params`" do
          expect(result).to be_success.with_data(params: {id: "", title: "", tags: [:important], sources: []})
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
