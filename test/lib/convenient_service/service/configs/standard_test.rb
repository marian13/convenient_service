# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "test_helper"

require "convenient_service"

##
# NOTE: This file checks only half of `ConvenientService::Service::Configs::Standard` functionality.
# The rest is verified by `spec/lib/convenient_service/service/configs/standard_spec.rb`.
#
class ConvenientService::Service::Configs::StandardTest < Minitest::Test
  context "class methods" do
    describe ".default_options" do
      context "when `RSpec` is NOT loaded" do
        should "return options with disabled `:rspec`" do
          default_options = ConvenientService::Config::Commands::NormalizeOptions.call(
            options: [
              :essential,
              :callbacks,
              :fallbacks,
              :inspect,
              :recalculation,
              :result_parents_trace,
              :code_review_automation,
              :short_syntax,
              :type_safety,
              :exception_services_trace,
              :per_instance_caching,
              :backtrace_cleaner,
              rspec: false
            ]
          )

          assert_equal(default_options, ConvenientService::Service::Configs::Standard.default_options)
        end

        should "return enabled options with disabled `:rspec` option" do
          assert_equal(
            [
              true,
              false
            ],
            [
              ConvenientService::Service::Configs::Standard.default_options.dup.subtract(:rspec).to_a.all?(&:enabled?),
              ConvenientService::Service::Configs::Standard.default_options.enabled?(:rspec)
            ]
          )
        end
      end
    end
  end
end
