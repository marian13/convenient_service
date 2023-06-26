# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStubbedResult
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
