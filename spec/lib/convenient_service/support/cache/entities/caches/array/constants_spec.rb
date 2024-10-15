# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Array::Constants, type: :standard do
  example_group "constants" do
    describe "::UNDEFINED" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::UNDEFINED).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::UNDEFINED.inspect).to eq("cache_value_undefined")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
