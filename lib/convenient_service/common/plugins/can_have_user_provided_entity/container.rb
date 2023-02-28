# frozen_string_literal: true

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
