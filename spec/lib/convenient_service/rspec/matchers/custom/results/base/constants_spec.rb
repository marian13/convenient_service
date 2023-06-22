# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::RSpec::Matchers::Custom::Results::Base::Constants do
  example_group "constants" do
    describe "::Triggers::BE_RESULT" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::Triggers::BE_RESULT).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::Triggers::BE_RESULT.inspect).to eq("BE_RESULT")
          end
        end
      end
    end

    describe "::DEFAULT_COMPARISON_METHOD" do
      it "returns `:==`" do
        expect(described_class::DEFAULT_COMPARISON_METHOD).to eq(:==)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
