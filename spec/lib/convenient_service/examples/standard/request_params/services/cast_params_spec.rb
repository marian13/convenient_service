# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::RequestParams::Services::CastParams do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      context "when `CastParams` is successful" do
        subject(:result) { described_class.result(params: original_params) }

        let(:original_params) do
          {
            id: "1000000",
            format: "html",
            title: "Avoid error shadowing",
            description: "Check the official User Docs",
            tags: "ruby",
            sources: "https://www.rubyguides.com/2019/07/ruby-instance-variables/"
          }
        end

        let(:casted_params) do
          {
            id: ConvenientService::Examples::Standard::RequestParams::Entities::ID.cast(original_params[:id]),
            format: ConvenientService::Examples::Standard::RequestParams::Entities::Format.cast(original_params[:format]),
            title: ConvenientService::Examples::Standard::RequestParams::Entities::Title.cast(original_params[:title]),
            description: ConvenientService::Examples::Standard::RequestParams::Entities::Description.cast(original_params[:description]),
            tags: [ConvenientService::Examples::Standard::RequestParams::Entities::Tag.cast(original_params[:tags])],
            sources: [ConvenientService::Examples::Standard::RequestParams::Entities::Source.cast(original_params[:sources])]
          }
        end

        it "returns `success` with original and casted params" do
          expect(result).to be_success.with_data(original_params: original_params, casted_params: casted_params)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
