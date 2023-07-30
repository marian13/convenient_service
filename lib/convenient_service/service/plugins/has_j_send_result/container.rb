# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Container
          include Support::DependencyContainer::Export

          export :"commands.is_result?" do |result|
            Commands::IsResult.call(result: result)
          end

          export :"constants.DEFAULT_ERROR_CODE" do
            Constants::DEFAULT_ERROR_CODE
          end
        end
      end
    end
  end
end
