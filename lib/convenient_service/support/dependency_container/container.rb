# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module DependencyContainer
      module Container
        include Export

        export :"constants.DEFAULT_SCOPE" do
          Constants::DEFAULT_SCOPE
        end

        export :"commands.AssertValidContainer" do
          Commands::AssertValidContainer
        end

        export :"commands.AssertValidScope" do
          Commands::AssertValidScope
        end
      end
    end
  end
end
