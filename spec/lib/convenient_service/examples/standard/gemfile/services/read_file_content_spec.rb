# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:result) { described_class.result(path: path) }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when reading file content is NOT successfull" do
        context "when `path` is NOT valid" do
          context "when `path` is `nil`" do
            let(:path) { nil }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(path: "Path is `nil`").of_service(described_class).of_step(:validate_path)
            end
          end

          context "when `path` is empty" do
            let(:path) { "" }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(path: "Path is empty").of_service(described_class).of_step(:validate_path)
            end
          end
        end

        context "when assertion that file exists is NOT successfull" do
          let(:path) { "not_existing_path" }

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists)
          end
        end

        context "when assertion that file is NOT empty is NOT successfull" do
          let(:temfile) { Tempfile.new }
          let(:path) { temfile.path }

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty)
          end
        end
      end

      context "when reading file content is successfull" do
        let(:temfile) { Tempfile.new.tap { |tempfile| tempfile.write(content) }.tap(&:close) }
        let(:path) { temfile.path }
        let(:content) { "some content" }

        it "returns success with content" do
          expect(result).to be_success.with_data({content: content}).of_service(described_class).of_step(:result)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
