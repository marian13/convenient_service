# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResults
        module Container
          include Support::DependencyContainer::Export

          export :"commands.SetServiceStubbedResult" do
            Commands::SetServiceStubbedResult
          end
        end
      end
    end
  end
end
