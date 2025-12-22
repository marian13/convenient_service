# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "can_have_stubbed_entries/commands"
require_relative "can_have_stubbed_entries/concern"
require_relative "can_have_stubbed_entries/constants"
require_relative "can_have_stubbed_entries/entities"
require_relative "can_have_stubbed_entries/middleware"

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        class << self
          def set_feature_stubbed_entry(feature, entry, arguments, value)
            Commands::SetFeatureStubbedEntry[feature: feature, entry: entry, arguments: arguments, value: value]
          end
        end
      end
    end
  end
end
