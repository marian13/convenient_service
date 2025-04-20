# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Dependencies::Queries::Gems::RSpec` functionality.
# The rest is verified by `test/lib/convenient_service/support/gems/rspec_test.rb`.
#
# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Dependencies::Queries::Gems::RSpec, type: :standard do
  example_group "class methods" do
    describe ".loaded?" do
      it "returns `true`" do
        expect(described_class.loaded?).to eq(true)
      end

      ##
      # NOTE: It tested by `test/lib/convenient_service/support/gems/rspec_test.rb`.
      #
      # context "when `RSpec` is NOT loaded" do
      #   it "returns `false`" do
      #     expect(described_class.loaded?).to eq(false)
      #   end
      # end
    end

    describe ".version" do
      it "returns version" do
        expect(described_class.version).to eq(ConvenientService::Dependencies::Queries::Version.new(RSpec::Core::Version::STRING))
      end

      context "when `RSpec` is NOT loaded" do
        before do
          allow(described_class).to receive(:loaded?).and_return(false)
        end

        it "returns null version" do
          expect(described_class.version).to be_instance_of(ConvenientService::Dependencies::Queries::Version::NullVersion)
        end
      end
    end

    describe ".current_example" do
      it "returns `current_example`" do |example|
        expect(described_class.current_example).to eq(example)
      end

      context "when `RSpec` is NOT loaded" do
        before do
          allow(described_class).to receive(:loaded?).and_return(false)
        end

        it "returns `nil`" do
          expect(described_class.current_example).to be_nil
        end
      end

      context "when `RSpec` does NOT respond to `current_example`" do
        before do
          allow(RSpec).to receive(:respond_to?).with(:current_example).and_return(false)
        end

        it "returns `nil`" do
          expect(described_class.current_example).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
