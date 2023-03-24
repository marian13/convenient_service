# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              class CastMethod < Support::Command
                ##
                # @!attribute [r] options
                #   @return [Object] Can be any type.
                #
                attr_reader :other

                ##
                # @!attribute [r] options
                #   @return [Hash]
                #
                attr_reader :options

                ##
                # @param other [Object] Can be any type.
                # @param options [Hash]
                #
                def initialize(other:, options:)
                  @other = other
                  @options = options
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method, nil]
                #
                # @internal
                #   NOTE: Read more about Composition over Inheritance.
                #   - https://en.wikipedia.org/wiki/Composition_over_inheritance
                #
                def call
                  return unless factory
                  return unless key
                  return unless name
                  return unless caller
                  return unless direction

                  Method.new(key: key, name: name, caller: caller, direction: direction)
                end

                private

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Factories::Base]
                #
                def factory
                  Utils::Object.memoize_including_falsy_values(self, :@factory) { Commands::CastMethodFactory.call(other: other) }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                #
                def key
                  Utils::Object.memoize_including_falsy_values(self, :@key) { factory&.create_key }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                #
                def name
                  Utils::Object.memoize_including_falsy_values(self, :@name) { factory&.create_name }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base]
                #
                def caller
                  Utils::Object.memoize_including_falsy_values(self, :@caller) { factory&.create_caller }
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Direction::Base]
                #
                def direction
                  Utils::Object.memoize_including_falsy_values(self, :@direction) { Commands::CastMethodDirection.call(other: other, options: options) }
                end
              end
            end
          end
        end
      end
    end
  end
end
