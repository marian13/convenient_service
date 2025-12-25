# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "test_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Dependencies::Queries::Gems::Minitest` functionality.
# The rest is verified by `spec/lib/convenient_service/support/gems/minitest_spec.rb`.
#
class ConvenientService::Dependencies::Queries::Gems::MinitestTest < Minitest::Test
  context "class methods" do
    describe ".loaded?" do
      context "when `Minitest` is loaded" do
        should "returns `true`" do
          assert_equal(true, ConvenientService::Dependencies::Queries::Gems::Minitest.loaded?)
        end
      end
    end

    describe ".version" do
      context "when `Minitest` is loaded" do
        should "return version" do
          assert_equal(ConvenientService::Dependencies::Queries::Version.new(Minitest::VERSION), ConvenientService::Dependencies::Queries::Gems::Minitest.version)
        end
      end
    end
  end
end
# rubocop:enable Minitest/NestedGroups
