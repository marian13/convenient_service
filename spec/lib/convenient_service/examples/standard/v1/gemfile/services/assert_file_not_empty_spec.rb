# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Gemfile::Services::AssertFileNotEmpty do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:result) { described_class.result(path: path) }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::V1::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when assertion that file is NOT empty is NOT successful" do
        context "when `path` is NOT valid" do
          context "when `path` is `nil`" do
            let(:path) { nil }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(path: "Path is `nil`").of_service(described_class).without_step
            end
          end

          context "when `path` is empty" do
            let(:path) { "" }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(path: "Path is empty").of_service(described_class).without_step
            end
          end
        end

        context "when file is empty" do
          ##
          # NOTE: Tempfile uses its own `let` in order to prevent its premature garbage collection.
          #
          let(:tempfile) { Tempfile.new }
          let(:path) { tempfile.path }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("File with path `#{path}` is empty").of_service(described_class).without_step
          end
        end
      end

      context "when assertion that file is NOT empty is successful" do
        ##
        # NOTE: Tempfile uses its own `let` in order to prevent its premature garbage collection.
        #
        let(:tempfile) { Tempfile.new.tap { |file| file.write("content") }.tap(&:close) }
        let(:path) { tempfile.path }

        it "returns `success`" do
          expect(result).to be_success.of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
