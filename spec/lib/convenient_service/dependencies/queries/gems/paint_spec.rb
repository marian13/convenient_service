# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Dependencies::Queries::Gems::Paint, type: :standard do
  example_group "class methods" do
    describe "version" do
      it "returns version" do
        expect(described_class.version).to eq(ConvenientService::Dependencies::Queries::Version.new(Paint::VERSION))
      end
    end

    context "when `Paint` is NOT loaded" do
      before do
        allow(described_class).to receive(:loaded?).and_return(false)
      end

      it "returns null version" do
        expect(described_class.version).to be_instance_of(ConvenientService::Dependencies::Queries::Version::NullVersion)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
