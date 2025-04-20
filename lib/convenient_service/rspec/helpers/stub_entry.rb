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
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubEntry]
        #
        def stub_entry(...)
          Classes::StubEntry.call(...)
        end

        ##
        # @param value [Object] Can be any type.
        # @return [ConvenientService::RSpec::Helpers::StubEntry::Classes::StubEntry::Entities::ValueSpec]
        #
        def return_value(value)
          Classes::StubEntry::Entities::ValueSpec.new(value: value)
        end
      end
    end
  end
end
