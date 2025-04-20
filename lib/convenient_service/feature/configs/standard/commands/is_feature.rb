# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
