# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/ContextWording, RSpec/MultipleExpectations, RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::FormatDate do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service_instance) { described_class.new(**default_options) }
  let(:default_options) { {date_string: date_string} }
  let(:date_string) { "5th Mar 2021 04:05:06+03:30" }

  let(:nil_failure_message) { '{:date_string=>"Date string can NOT be nil"}' }
  let(:empty_failure_message) { '{:date_string=>"Date string can NOT be empty"}' }
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

    context "when there is display argument" do
      context "when its value is true" do
        let(:default_options) { {date_string: date_string, display: true} }

        context "when date_string is nil" do
          let(:date_string) { nil }

          it "prints fail result" do
            expect { result }.to output("\e[35;1m#{nil_failure_message}\e[0m\n").to_stdout # `[35;1m[0m` means magenta color
          end
        end

        context "when date_string is empty" do
          let(:date_string) { "" }

          it "prints fail result" do
            expect { result }.to output("\e[35;1m#{empty_failure_message}\e[0m\n").to_stdout # `[35;1m[0m` means magenta color
          end
        end

        context "when all params are valid" do
          it "prints success result" do
            expect { result }.to output("\e[32;1m#{success_message}\e[0m\n").to_stdout # `[32;1m[0m` means green color
          end
        end
      end

      context "when its value is false" do
        let(:default_options) { {date_string: date_string, display: false} }

        context "when date_string is nil" do
          let(:date_string) { nil }

          it "does NOT print result" do
            expect { result }.not_to output("\e[35;1m#{nil_failure_message}\e[0m\n").to_stdout # `[35;1m[0m` means magenta color
          end
        end

        context "when date_string is empty" do
          let(:date_string) { "" }

          it "does NOT print result" do
            expect { result }.not_to output("\e[35;1m#{empty_failure_message}\e[0m\n").to_stdout # `[35;1m[0m` means magenta color
          end
        end

        context "when all params are valid" do
          it "does NOT print success result" do
            expect { result }.not_to output("\e[32;1m#{success_message}\e[0m\n").to_stdout # `[32;1m[0m` means green color
          end
        end
      end
    end

    context "when there is no display argument" do
      context "when date_string is nil" do
        let(:date_string) { nil }

        it "does NOT print result" do
          expect { result }.not_to output("\e[35;1m#{nil_failure_message}\e[0m\n").to_stdout # `[35;1m[0m` means magenta color
        end
      end

      context "when date_string is empty" do
        let(:date_string) { "" }

        it "does NOT print result" do
          expect { result }.not_to output("\e[35;1m#{empty_failure_message}\e[0m\n").to_stdout # `[35;1m[0m` means magenta color
        end
      end

      context "when all params are valid" do
        it "does NOT print success result" do
          expect { result }.not_to output("\e[32;1m#{success_message}\e[0m\n").to_stdout # `[32;1m[0m` means green color
        end
      end
    end
  end
end
# rubocop:enable RSpec/ContextWording, RSpec/MultipleExpectations, RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
