# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::RSpec::Helpers::Classes::StubEntry::Constants, type: :standard do
  example_group "constants" do
    describe "::Triggers::STUB_ENTRY" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::Triggers::STUB_ENTRY).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::Triggers::STUB_ENTRY.inspect).to eq("STUB_ENTRY")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
