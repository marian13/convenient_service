# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "standard/commands"

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
            use ConvenientService::Plugins::Feature::CanHaveEntries::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Common::HasInstanceProxy::Concern if options.enabled?(:essential)
            use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Concern if options.enabled?(:rspec)
          end

          middlewares :new, scope: :class do
            use ConvenientService::Plugins::Common::HasInstanceProxy::Middleware if options.enabled?(:essential)
          end

          middlewares :trigger, scope: :class do
            use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware if options.enabled?(:rspec)
          end

          middlewares :trigger do
            use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware if options.enabled?(:rspec)
          end
        end

        class << self
          ##
          # Checks whether a class is a feature class.
          #
          # @api public
          #
          # @param feature_class [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Feature
          #     include ConvenientService::Feature::Standard::Config
          #
          #     entry :main
          #
          #     def main
          #       :main_entry_value
          #     end
          #   end
          #
          #    ConvenientService::Feature::Configs::Standard.feature_class?(Feature)
          #   # => true
          #
          #    ConvenientService::Feature::Configs::Standard.feature_class?(42)
          #   # => false
          #
          def feature_class?(feature_class)
            Commands::IsFeatureClass[feature_class: feature_class]
          end

          ##
          # Checks whether an object is a feature instance.
          #
          # @api public
          #
          # @param feature [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Feature
          #     include ConvenientService::Feature::Standard::Config
          #
          #     entry :main
          #
          #     def main
          #       :main_entry_value
          #     end
          #   end
          #
          #   feature = Feature.new
          #
          #    ConvenientService::Feature::Configs::Standard.feature?(feature)
          #   # => true
          #
          #    ConvenientService::Feature::Configs::Standard.feature?(42)
          #   # => false
          #
          def feature?(feature)
            Commands::IsFeature[feature: feature]
          end
        end
      end
    end
  end
end
