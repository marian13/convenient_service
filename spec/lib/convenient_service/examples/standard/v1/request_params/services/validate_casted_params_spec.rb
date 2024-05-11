# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Services::ValidateCastedParams, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(original_params: original_params, casted_params: casted_params) }

      let(:original_params) do
        {
          id: original_id,
          format: original_format,
          title: original_title,
          description: original_description,
          tags: original_tags,
          sources: original_sources
        }
      end

      let(:casted_params) do
        {
          id: casted_id,
          format: casted_format,
          title: casted_title,
          description: casted_description,
          tags: casted_tags,
          sources: casted_sources
        }
      end

      let(:original_id) { 1_000 }
      let(:original_format) { "json" }
      let(:original_title) { "Avoid error shadowing" }
      let(:original_description) { "Check the official User Docs" }
      let(:original_tags) { "ruby" }
      let(:original_sources) { "https://www.rubyguides.com/2019/07/ruby-instance-variables/" }

      let(:casted_id) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::ID.cast(original_params[:id]) }
      let(:casted_format) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::Format.cast(original_params[:format]) }
      let(:casted_title) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::Title.cast(original_params[:title]) }
      let(:casted_description) { ConvenientService::Examples::Standard::V1::RequestParams::Entities::Description.cast(original_params[:description]) }
      let(:casted_tags) { [ConvenientService::Examples::Standard::V1::RequestParams::Entities::Tag.cast(original_params[:tags])] }
      let(:casted_sources) { [ConvenientService::Examples::Standard::V1::RequestParams::Entities::Source.cast(original_params[:sources])] }

      context "when `ValidateCastedParams` is NOT successful" do
        context "when params are NOT valid" do
          context "when original id is NOT castable" do
            let(:original_id) { nil }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Failed to cast `#{original_id.inspect}` into `ID`")
            end
          end

          context "when original format is NOT castable" do
            let(:casted_format) { nil }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Failed to cast `#{original_format.inspect}` into `Format`")
            end
          end

          context "when original title is NOT castable" do
            let(:casted_title) { nil }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Failed to cast `#{original_title.inspect}` into `Title`")
            end
          end

          context "when original description is NOT castable" do
            let(:casted_description) { nil }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Failed to cast `#{original_description.inspect}` into `Description`")
            end
          end
        end
      end

      context "when `ValidateCastedParams` is successful" do
        it "returns success without data" do
          expect(result).to be_success.without_data
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
