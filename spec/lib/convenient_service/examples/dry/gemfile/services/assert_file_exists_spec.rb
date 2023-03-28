# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::AssertFileExists do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(path: path) }
  let(:path) { double }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { service.result }

      context "when assertion that file exists is NOT successful" do
        context "when `path` is NOT present" do
          let(:path) { "" }

          it "returns `failure` with `data`" do
            expect(result).to be_failure.with_data(path: "must be filled").of_service(described_class).without_step
          end
        end

        context "when file with `path` does NOT exist" do
          let(:path) { "non_existing_path" }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("File with path `#{path}` does NOT exist").of_service(described_class).without_step
          end
        end
      end

      context "when assertion that file exists is successful" do
        ##
        # NOTE: Tempfile uses its own let in order to prevent its premature garbage collection.
        #
        let(:tempfile) { Tempfile.new }
        let(:path) { tempfile.path }

        it "returns `success`" do
          expect(result).to be_success.without_data.of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
