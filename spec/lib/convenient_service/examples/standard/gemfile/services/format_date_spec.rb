# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
# rubocop:disable RSpec/MultipleMemoizedHelpers
# rubocop:disable RSpec/MultipleExpectations
# rubocop:disable RSpec/ContextWording
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::FormatDate do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service_instance) { described_class.new(**default_options) }
  let(:default_options) { {date_string: date_string} }
  let(:date_string) { "5th Mar 2021 04:05:06+03:30" }

  let(:nil_failure_message) { "date_string Date string can NOT be nil" }
  let(:empty_failure_message) { "date_string Date string can NOT be empty" }
  let(:success_message) { '{:formatted_date=>"05-03-2021"}' }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "attributes" do
    subject { service_instance }

    it { is_expected.to have_attr_reader(:date_string) }
  end

  describe "#result" do
    subject(:result) { service_instance.result }

    context "when @print_out value is true" do
      context "and date_string is nil" do
        let(:date_string) { nil }

        it "prints and returns fail result" do
          expect { result }.to output("\e[31;1m#{nil_failure_message}\e[0m\n").to_stdout # `[31;1m[0m` means red color

          expect(result).to be_failure
        end
      end

      context "and date_string is empty" do
        let(:date_string) { "" }

        it "prints and returns fail result" do
          expect { result }.to output("\e[31;1m#{empty_failure_message}\e[0m\n").to_stdout # `[31;1m[0m` means red color

          expect(result).to be_failure
        end
      end

      context "and all params are valid" do
        it "prints and returns success result" do
          expect { result }.to output("\e[32;1m#{success_message}\e[0m\n").to_stdout # `[32;1m[0m` means green color

          expect(result).to be_success.with_data(formatted_date: "05-03-2021")
        end
      end
    end

    context "when @print_out value is false" do
      let(:default_options) { { date_string: date_string, print_out: false } }

      context "and date_string is nil" do
        let(:date_string) { nil }

        it "returns fail result without printing" do
          expect { result }.not_to output("\e[31;1m#{nil_failure_message}\e[0m\n").to_stdout # `[31;1m[0m` means red color

          expect(result).to be_failure
        end
      end

      context "and date_string is empty" do
        let(:date_string) { "" }

        it "returns fail result without printing" do
          expect { result }.not_to output("\e[31;1m#{empty_failure_message}\e[0m\n").to_stdout # `[31;1m[0m` means red color

          expect(result).to be_failure
        end
      end

      context "and all params are valid" do
        let(:date_string) { "5th Mar 2021 04:05:06+03:30" }

        it "returns success result without printing" do
          expect { result }.not_to output("\e[32;1m#{success_message}\e[0m\n").to_stdout # `[32;1m[0m` means green color

          expect(result).to be_success.with_data(formatted_date: "05-03-2021")
        end
      end
    end
  end
end
# rubocop:enable RSpec/ContextWording
# rubocop:enable RSpec/MultipleExpectations
# rubocop:enable RSpec/MultipleMemoizedHelpers
# rubocop:enable RSpec/NestedGroups
