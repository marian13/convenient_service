# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "test_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Dependencies::Queries::Gems::RSpec` functionality.
# The rest is verified by `spec/lib/convenient_service/support/gems/rspec_spec.rb`.
#
class ConvenientService::Dependencies::Queries::Gems::RSpecTest < Minitest::Test
  context "class methods" do
    describe ".loaded?" do
      context "when `RSpec` is NOT loaded" do
        should "returns `false`" do
          assert_equal(false, ConvenientService::Dependencies::Queries::Gems::RSpec.loaded?)
        end
      end
    end

    describe ".version" do
      context "when `RSpec` is NOT loaded" do
        should "return null version" do
          assert_instance_of(ConvenientService::Dependencies::Queries::Version::NullVersion, ConvenientService::Dependencies::Queries::Gems::RSpec.version)
        end
      end
    end

    describe ".current_example" do
      context "when `RSpec` is NOT loaded" do
        should "returns `nil`" do
          assert_nil(ConvenientService::Dependencies::Queries::Gems::RSpec.current_example)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
