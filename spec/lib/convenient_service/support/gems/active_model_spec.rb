# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Gems::ActiveModel do
  example_group "class methods" do
    if described_class.loaded?
      describe "version" do
        it "returns version" do
          expect(described_class.version).to eq(ConvenientService::Support::Version.new(::ActiveModel.version))
        end
      end
    end

    context "when `ActiveModel` is NOT loaded" do
      before do
        allow(described_class).to receive(:loaded?).and_return(false)
      end

      it "returns null version" do
        expect(described_class.version).to be_instance_of(ConvenientService::Support::Version::NullVersion)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
