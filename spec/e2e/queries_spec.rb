# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass, RSpec/MultipleExpectations
RSpec.describe "Queries", type: [:standard, :e2e] do
  let(:ruby_engine_from_queries) { ["ruby", "jruby", "truffleruby"].find { |engine| ConvenientService::Dependencies.ruby.public_send("#{engine}?") } }
  let(:ruby_engine_from_language) { RUBY_ENGINE.to_s }

  ##
  # NOTE: `ConvenientService::Dependencies.ruby.ruby?`, `ConvenientService::Dependencies.ruby.jruby?`, and `ConvenientService::Dependencies.ruby.truffleruby?` are mocked in their direct specs. This `e2e` spec checks them without mocks.
  #
  # rubocop:disable RSpec/MultipleExpectations
  specify do
    expect(ruby_engine_from_queries).not_to be_nil
    expect(ruby_engine_from_language).to match(ruby_engine_from_queries)
  end
  # rubocop:enable RSpec/MultipleExpectations
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass
