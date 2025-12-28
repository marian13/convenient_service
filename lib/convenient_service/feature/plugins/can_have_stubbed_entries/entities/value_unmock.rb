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
          class ValueUnmock
            ##
            # @param feature_class [Class<ConvenientService::Feature>]
            # @param entry_name [Symbol, String]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [void]
            #
            def initialize(feature_class: nil, entry_name: nil, arguments: nil)
              @feature_class = feature_class
              @entry_name = entry_name
              @arguments = arguments
            end

            ##
            # @param feature_class [Class<ConvenientService::Feature>]
            # @param entry_name [Symbol, String]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueUnmock]
            #
            def for(feature_class, entry_name, arguments)
              self.class.new(feature_class: feature_class, entry_name: entry_name, arguments: arguments)
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueUnmock]
            #
            def register
              Commands::DeleteFeatureStubbedEntry[feature: feature_class, entry: entry_name, arguments: arguments]

              self
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueUnmock]
            #
            alias_method :apply, :register

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if feature_class != other.feature_class
              return false if entry_name != other.entry_name
              return false if arguments != other.arguments

              true
            end

            protected

            ##
            # @!attribute [r] feature_class
            #   @return [Class<ConvenientService::Feature>]
            #
            attr_reader :feature_class

            ##
            # @!attribute [r] entry_name
            #   @return [Symbol, String]
            #
            attr_reader :entry_name

            ##
            # @!attribute [r] arguments
            #   @return [ConvenientService::Support::Arguments]
            #
            attr_reader :arguments
          end
        end
      end
    end
  end
end
