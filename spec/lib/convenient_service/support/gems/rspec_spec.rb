# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Gems::RSpec do
  example_group "class methods" do
    describe "version" do
      it "return version" do
        expect(described_class.version).to eq(ConvenientService::Support::Version.new(RSpec::Core::Version::STRING))
      end

      context "when `RSpec` is NOT loaded" do
        before do
          allow(described_class).to receive(:loaded?).and_return(false)
        end

        it "return null version" do
          expect(described_class.version).to be_instance_of(ConvenientService::Support::Version::NullVersion)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
