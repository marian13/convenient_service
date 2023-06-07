# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Container
        include Export

        export :"constants.DEFAULT_ALIAS_SLUG" do
          Constants::DEFAULT_ALIAS_SLUG
        end

        export :"constants.DEFAULT_PREPEND" do
          Constants::DEFAULT_PREPEND
        end

        export :"constants.DEFAULT_SCOPE" do
          Constants::DEFAULT_SCOPE
        end

        export :"commands.AssertValidContainer" do
          Commands::AssertValidContainer
        end

        export :"commands.AssertValidScope" do
          Commands::AssertValidScope
        end

        export :"commands.AssertValidMethod" do
          Commands::AssertValidMethod
        end

        export :"commands.FetchImportedScopedMethods" do
          Commands::FetchImportedScopedMethods
        end

        export :"commands.FetchNamespace" do
          Commands::FetchNamespace
        end

        export :"entities.Method" do
          Entities::Method
        end
      end
    end
  end
end
