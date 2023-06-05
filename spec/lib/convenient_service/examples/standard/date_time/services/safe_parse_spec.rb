# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::DateTime::Services::SafeParse do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:result) { described_class.result(string: string, format: format) }
  let(:string) { "24-02-2022" }
  let(:format) { "%d-%m-%Y" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when safe parsing is NOT successful" do
        context "when `string` has invalid format" do
          let(:string) { "foo" }

          let(:data) { {exception: instance_of(Date::Error)} }
          let(:message) { "Failed to parse `DateTime` object from `#{string}` with `#{format}`" }

          it "returns `failure` with `data` and `message`" do
            expect(result).to be_failure.with_data(data).and_message(message).comparing_by(:===)
          end
        end
      end

      context "when safe parsing is successful" do
        let(:string) { "24-02-2022" }
        let(:format) { "%d-%m-%Y" }
        let(:date_time) { DateTime.strptime(string, format) }

        it "returns `success` with `DataTime` object" do
          expect(result).to be_success.with_data(date_time: date_time).of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
