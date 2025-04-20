# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CanHaveUserProvidedEntity
        module Container
          include Support::DependencyContainer::Export

          export :"commands.FindOrCreateEntity" do
            Commands::FindOrCreateEntity
          end
        end
      end
    end
  end
end
