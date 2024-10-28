# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      module Standard
        module Commands
          class IsFeature < Support::Command
            ##
            # @!attribute [r] feature
            #   @return [Object] Can be any type.
            #
            attr_reader :feature

            ##
            # @param feature [Object] Can be any type.
            # @return [void]
            #
            def initialize(feature:)
              @feature = feature
            end

            ##
            # @return [Boolean]
            #
            def call
              Commands::IsFeatureClass[feature_class: feature.class]
            end
          end
        end
      end
    end
  end
end
