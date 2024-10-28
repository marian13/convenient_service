# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      module Standard
        module Commands
          class IsFeatureClass < Support::Command
            ##
            # @!attribute [r] feature_class
            #   @return [Object] Can be any type.
            #
            attr_reader :feature_class

            ##
            # @param feature_class [Object] Can be any type.
            # @return [void]
            #
            def initialize(feature_class:)
              @feature_class = feature_class
            end

            ##
            # @return [Boolean]
            #
            def call
              return unless feature_class.instance_of?(::Class)

              feature_class.include?(Feature::Core)
            end
          end
        end
      end
    end
  end
end
