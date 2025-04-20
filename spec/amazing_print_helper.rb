# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "spec_helper"

require_relative "support/convenient_service/amazing_print"

##
# NOTE: Runs only spec with specific tag.
# - https://github.com/rspec/rspec-core/blob/main/Filtering.md#rspecconfigure
#
RSpec.configure do |config|
  config.filter_run_including type: :amazing_print
end
