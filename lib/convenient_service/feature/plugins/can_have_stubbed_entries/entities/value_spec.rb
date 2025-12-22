# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        module Entities
          class ValueSpec
            ##
            # @param value [Object] Can be any type.
            # @param feature_class [Class<ConvenientService::Feature>]
            # @return [void]
            #
            def initialize(value:, feature_class: nil)
              @value = value
              @feature_class = feature_class
            end

            ##
            # @param feature_class [Class<ConvenientService::Feature>]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueSpec]
            #
            def for(feature_class)
              self.class.new(value: value, feature_class: feature_class)
            end

            ##
            # @return [Object]
            #
            # @internal
            #    TODO: Assert.
            #
            def calculate_value
              value
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if value != other.value
              return false if feature_class != other.feature_class

              true
            end

            protected

            ##
            # @!attribute [r] value
            #   @return [Object] Can be any type.
            #
            attr_reader :value

            ##
            # @!attribute [r] feature_class
            #   @return [Class<ConvenientService::Feature>]
            #
            attr_reader :feature_class
          end
        end
      end
    end
  end
end
