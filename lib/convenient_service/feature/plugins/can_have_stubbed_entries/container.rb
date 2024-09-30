# frozen_string_literal: true

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
