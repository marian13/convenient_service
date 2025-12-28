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
          class ValueMock
            ##
            # @!attribute [r] value
            #   @return [Object] Can be any type.
            #
            attr_reader :value

            ##
            # @param value [Object] Can be any type.
            # @param feature_class [Class<ConvenientService::Feature>]
            # @param entry_name [Symbol, String]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [void]
            #
            def initialize(value:, feature_class: nil, entry_name: nil, arguments: nil)
              @value = value
              @feature_class = feature_class
              @entry_name = entry_name
              @arguments = arguments
            end

            ##
            # @param feature_class [Class<ConvenientService::Feature>]
            # @param entry_name [Symbol, String]
            # @param arguments [ConvenientService::Support::Arguments]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock]
            #
            def for(feature_class, entry_name, arguments)
              self.class.new(value: value, feature_class: feature_class, entry_name: entry_name, arguments: arguments)
            end

            ##
            # @param block [Proc, nil]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock]
            #
            def register(&block)
              Commands::SetFeatureStubbedEntry[feature: feature_class, entry: entry_name, arguments: arguments, value: value]

              return self unless block

              begin
                yield
              ensure
                Commands::DeleteFeatureStubbedEntry[feature: feature_class, entry: entry_name, arguments: arguments]
              end
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock]
            #
            alias_method :apply, :register

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock]
            #
            def unregister
              Commands::DeleteFeatureStubbedEntry[feature: feature_class, entry: entry_name, arguments: arguments]

              self
            end

            ##
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::ValueMock]
            #
            alias_method :revert, :unregister

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if value != other.value
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
