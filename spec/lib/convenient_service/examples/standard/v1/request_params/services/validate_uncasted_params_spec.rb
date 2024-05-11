# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Services::ValidateUncastedParams, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(params: params) }

      let(:params) do
        {
          id: id,
          format: format,
          title: title,
          description: description,
          tags: tags,
          sources: sources
        }
      end

      let(:id) { 999 }
      let(:format) { "json" }
      let(:title) { "Avoid error shadowing" }
      let(:description) { "Check the official User Docs" }
      let(:tags) { "ruby" }
      let(:sources) { "https://www.rubyguides.com/2019/07/ruby-instance-variables/" }

      context "when `ValidateUncastedParams` is NOT successful" do
        context "when params are NOT valid" do
          context "when ID is NOT present" do
            let(:id) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("ID is NOT present")
            end
          end

          context "when ID is NOT valid integer" do
            let(:id) { "abc" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("ID `#{id}` is NOT a valid integer")
            end
          end

          context "when format is NOT json" do
            let(:format) { "html" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Format `#{format}` is NOT supported, only JSON is allowed")
            end
          end

          context "when title is NOT present" do
            let(:title) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Title is NOT present")
            end
          end

          context "when description is NOT present" do
            let(:description) { "" }

            it "returns `error` with `message`" do
              expect(result).to be_error.with_message("Description is NOT present")
            end
          end
        end
      end

      context "when `ValidateUncastedParams` is successful" do
        it "returns `success` without data" do
          expect(result).to be_success.without_data
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
