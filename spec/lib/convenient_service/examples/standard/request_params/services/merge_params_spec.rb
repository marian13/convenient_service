# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::MergeParams do
  example_group "class methods" do
    describe ".result" do
      include ConvenientService::RSpec::Matchers::Results

      subject(:result) { described_class.result(params_from_path: params_from_path, params_from_body: params_from_body) }

      let(:params_from_path) { {id: 1, format: "html"} }

      let(:params_from_body) do
        {
          title: "Avoid error shadowing",
          description: "Check the official User Docs",
          tags: "ruby",
          sources: "https://www.rubyguides.com/2019/07/ruby-instance-variables/"
        }
      end

      let(:merged_params) do
        {
          id: 1,
          format: "html",
          title: "Avoid error shadowing",
          description: "Check the official User Docs",
          tags: "ruby",
          sources: "https://www.rubyguides.com/2019/07/ruby-instance-variables/"
        }
      end

      it "returns success with original merged params" do
        expect(result).to be_success.with_data(params: merged_params)
      end

      context "when `params_from_path` and `params_from_body` have same keys" do
        let(:params_from_body) do
          {
            format: "json",
            title: "Avoid error shadowing",
            description: "Check the official User Docs",
            tags: "ruby",
            sources: "https://www.rubyguides.com/2019/07/ruby-instance-variables/"
          }
        end

        let(:merged_params) do
          {
            id: 1,
            format: "json",
            title: "Avoid error shadowing",
            description: "Check the official User Docs",
            tags: "ruby",
            sources: "https://www.rubyguides.com/2019/07/ruby-instance-variables/"
          }
        end

        it "takes value from `params_from_body`" do
          expect(result).to be_success.with_data(params: merged_params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
