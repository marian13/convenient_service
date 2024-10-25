# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      ##
      # Default configuration for the user-defined features.
      #
      module Standard
        include ConvenientService::Config

        default_options do
          [
            :essential,
            rspec: Dependencies.rspec.loaded?
          ]
        end

        included do
          include ConvenientService::Feature::Core

          concerns do
            use ConvenientService::Plugins::Feature::CanHaveEntries::Concern if options.include?(:essential)
            use ConvenientService::Plugins::Common::HasInstanceProxy::Concern if options.include?(:essential)
            use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Concern if options.include?(:rspec)
          end

          middlewares :new, scope: :class do
            use ConvenientService::Plugins::Common::HasInstanceProxy::Middleware if options.include?(:essential)
          end

          middlewares :trigger, scope: :class do
            use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware if options.include?(:rspec)
          end

          middlewares :trigger do
            use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware if options.include?(:rspec)
          end
        end
      end
    end
  end
end
