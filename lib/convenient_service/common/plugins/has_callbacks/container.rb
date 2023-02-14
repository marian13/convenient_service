# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Container
          include Support::DependencyContainer::Export

          export :"entities.Callback" do
            Entities::Callback
          end
        end
      end
    end
  end
end
