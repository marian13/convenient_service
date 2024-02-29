# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when `SuccessService` is successful" do
        context "when `data` is NOT passed" do
          subject(:result) { described_class.result }

          let(:default_data) { {foo: :bar} }

          it "returns `success` with `default data`" do
            expect(result).to be_success.with_data(default_data).of_service(described_class).without_step
          end
        end
      end

      context "when `data` is passed" do
        subject(:result) { described_class.result(data: data) }

        let(:data) { {baz: :qux, quux: :quuz} }

        it "returns `success` with that passed `data`" do
          expect(result).to be_success.with_data(data).of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
