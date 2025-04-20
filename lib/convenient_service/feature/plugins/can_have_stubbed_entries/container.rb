# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        module Container
          include Support::DependencyContainer::Export

          export :"commands.SetFeatureStubbedEntry" do
            Commands::SetFeatureStubbedEntry
          end
        end
      end
    end
  end
end
