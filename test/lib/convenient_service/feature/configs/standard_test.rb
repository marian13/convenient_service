# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "test_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Feature::Configs::Standard` functionality.
# The rest is verified by `spec/lib/convenient_service/feature/configs/standard_spec.rb`.
#
class ConvenientService::Feature::Configs::StandardTest < Minitest::Test
  context "class methods" do
    describe ".default_options" do
      context "when `RSpec` is NOT loaded" do
        should "return options without `:rspec`" do
          default_options = Set[:essential]

          assert_equal(default_options, ConvenientService::Feature::Configs::Standard.default_options)
        end
      end
    end
  end
end
