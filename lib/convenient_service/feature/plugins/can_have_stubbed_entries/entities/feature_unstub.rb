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
          class FeatureUnstub
            ##
            # @param feature_class [Class<ConvenientService::Feature>]
            # @param entry_name [Symbol, String]
            # @return [void]
            #
            # @internal
            #   NOTE: `@arguments = nil` means "match any arguments".
            #
            def initialize(feature_class:, entry_name:)
              @feature_class = feature_class
              @entry_name = entry_name
              @arguments = nil
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureUnstub]
            #
            def with_arguments(...)
              @arguments = Support::Arguments.new(...)

              self
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureUnstub]
            #
            # @internal
            #   NOTE: `@arguments = nil` means "match any arguments".
            #
            def with_any_arguments(...)
              @arguments = nil

              self
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureUnstub]
            #
            def without_arguments
              @arguments = Support::Arguments.null_arguments

              self
            end

            ##
            # @param value_unmock [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueUnmock]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureUnstub]
            #
            def to(value_unmock)
              @value_unmock = value_unmock.for(feature_class, entry_name, arguments)

              @value_unmock.register

              self
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueUnmock]
            #
            def to_return_value_mock
              @value_unmock = Entities::ValueUnmock.new(feature_class: feature_class, entry_name: entry_name, arguments: arguments)
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if feature_class != other.feature_class
              return false if entry_name != other.entry_name
              return false if arguments != other.arguments
              return false if value_unmock != other.value_unmock

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

            ##
            # @!attribute [r] value_unmock
            #   @return [ConvenientService::RSpec::Helpers::Classes::StubEntry::Entities::ValueMock]
            #
            attr_reader :value_unmock
          end
        end
      end
    end
  end
end
