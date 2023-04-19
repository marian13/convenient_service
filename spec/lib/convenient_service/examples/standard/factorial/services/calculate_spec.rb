# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Factorial::Services::Calculate do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:result) { described_class.result(number: number, timeout_seconds: timeout_seconds) }
  let(:number) { 10 }
  let(:timeout_seconds) { 5 }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when calculation is NOT successful" do
        context "when `number` is NOT valid" do
          context "when `number` is `nil`" do
            let(:number) { nil }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(number: "is `nil`").of_service(described_class).without_step
            end
          end

          context "when `number` is NOT integer" do
            let(:number) { "foo" }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(number: "is NOT an integer").of_service(described_class).without_step
            end
          end

          context "when `number` is lower than `0`" do
            let(:number) { -1 }

            it "returns `failure` with `data`" do
              expect(result).to be_failure.with_data(number: "is lower than `0`").of_service(described_class).without_step
            end
          end
        end

        context "when file with `path` does NOT exist" do
          let(:number) { 200_000 }
          let(:timeout_seconds) { 1 }

          it "returns `error` with `message`" do
            expect(result).to be_error.with_message("Timeout (`#{timeout_seconds}` seconds) is exceeded for `#{number}`").of_service(described_class).without_step
          end
        end
      end

      context "when calculation is successful" do
        let(:number) { 10 }
        let(:factorial) { 10 * 9 * 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1 }

        it "returns `success` with factorial" do
          expect(result).to be_success.with_data(factorial: factorial).of_service(described_class).without_step
        end

        context "when `timeout_seconds` are NOT passed" do
          let(:result) { described_class.result(number: number) }

          it "defaults to `10`" do
            expect(result.service.timeout_seconds).to eq(10)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
