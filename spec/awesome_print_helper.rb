# frozen_string_literal: true

require_relative "spec_helper"

require_relative "support/convenient_service/awesome_print"

##
# NOTE: Runs only spec with specific tag.
# - https://github.com/rspec/rspec-core/blob/main/Filtering.md#rspecconfigure
#
RSpec.configure do |config|
  config.filter_run_including type: :awesome_print
end
