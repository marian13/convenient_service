# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module StubEntry
        ##
        # @param feature_class [Class<ConvenientService::Feature>]
        # @param entry_name [Symbol, String]
        # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::StubbedEntry]
        #
        def stub_entry(feature_class, entry_name)
          feature_class.stub_entry(entry_name)
        end

        ##
        # @param value [Object] Can be any type.
        # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueSpec]
        #
        def return_value(value)
          ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueSpec.new(value: value)
        end
      end
    end
  end
end
