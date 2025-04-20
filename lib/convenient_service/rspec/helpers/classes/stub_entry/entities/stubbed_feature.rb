# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class StubEntry < Support::Command
          module Entities
            class StubbedFeature
              include Support::DependencyContainer::Import

              ##
              # @internal
              #   TODO: Implement shorter form in the following way:
              #
              #   import \
              #     command: :SetFeatureStubbedEntry,
              #     from: ConvenientService::Feature::Plugins::CanHaveStubbedEntries
              #
              import \
                :"commands.SetFeatureStubbedEntry",
                from: ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Container

              ##
              # @param feature_class [ConvenientService::Feature]
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
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              def with_arguments(...)
                @arguments = Support::Arguments.new(...)

                self
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              # @internal
              #   NOTE: `@arguments = nil` means "match any arguments".
              #
              def with_any_arguments(...)
                @arguments = nil

                self
              end

              ##
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              def without_arguments
                @arguments = Support::Arguments.null_arguments

                self
              end

              ##
              # @param value_spec [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::StubService]
              #
              def to(value_spec)
                @value_spec = value_spec

                feature_class.commit_config!(trigger: Constants::Triggers::STUB_ENTRY)

                commands.SetFeatureStubbedEntry[feature: feature_class, entry: entry_name, arguments: arguments, value: value]

                self
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
                return false if value_spec != other.value_spec

                true
              end

              protected

              ##
              # @!attribute [r] feature_class
              #   @return [ConvenientService::Feature]
              #
              attr_reader :feature_class

              ##
              # @!attribute [r] entry_name
              #   @return [Symbol, String]
              #
              attr_reader :entry_name

              ##
              # @!attribute [r] arguments
              #   @return [Hash]
              #
              attr_reader :arguments

              ##
              # @!attribute [r] value_spec
              #   @return [ConvenientService::RSpec::Helpers::Classes::StubEntry::Entities::ValueSpec]
              #
              attr_reader :value_spec

              private

              ##
              # @return [Object] Can be any type.
              #
              def value
                @value ||= value_spec.for(feature_class).calculate_value
              end
            end
          end
        end
      end
    end
  end
end
