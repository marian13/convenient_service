# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Ruby do
  example_group "class methods" do
    describe "version" do
      it "returns version" do
        expect(described_class.version).to eq(ConvenientService::Support::Version.new(RUBY_VERSION))
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
