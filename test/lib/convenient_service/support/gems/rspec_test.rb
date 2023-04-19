# frozen_string_literal: true

require "test_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Support::Gems::RSpec` functionality.
# The rest is verified by `spec/lib/convenient_service/support/gems/rspec_spec.rb`.
#
class ConvenientService::Support::Gems::RSpecTest < Minitest::Test
  context "class methods" do
    describe ".loaded?" do
      context "when `RSpec` is NOT loaded" do
        should "returns `false`" do
          assert_equal(false, ConvenientService::Support::Gems::RSpec.loaded?)
        end
      end
    end

    describe ".version" do
      context "when `RSpec` is NOT loaded" do
        should "return null version" do
          assert_instance_of(ConvenientService::Support::Version::NullVersion, ConvenientService::Support::Gems::RSpec.version)
        end
      end
    end

    describe ".current_example" do
      context "when `RSpec` is NOT loaded" do
        should "returns `nil`" do
          assert_nil(ConvenientService::Support::Gems::RSpec.current_example)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
