# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Dependencies::Queries::Gems::Minitest` functionality.
# The rest is verified by `test/lib/convenient_service/support/gems/minitest_test.rb`.
#
# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Dependencies::Queries::Gems::Minitest, type: :standard do
  example_group "class methods" do
    describe ".loaded?" do
      it "returns `false`" do
        expect(described_class.loaded?).to be(false)
      end

      ##
      # NOTE: It tested by `test/lib/convenient_service/support/gems/minitest_test.rb`.
      #
      # context "when `Minitest` is loaded" do
      #   it "returns `true`" do
      #     expect(described_class.loaded?).to eq(true)
      #   end
      # end
      ##
    end

    describe ".version" do
      ##
      # NOTE: It tested by `test/lib/convenient_service/support/gems/minitest_test.rb`.
      #
      # it "returns version" do
      #   expect(described_class.version).to eq(ConvenientService::Dependencies::Queries::Version.new(Minitest::Version))
      # end
      ##

      context "when `Minitest` is NOT loaded" do
        before do
          allow(described_class).to receive(:loaded?).and_return(false)
        end

        it "returns null version" do
          expect(described_class.version).to be_instance_of(ConvenientService::Dependencies::Queries::Version::NullVersion)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
