# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Commands
          class CastCaller < Support::Command
            ##
            # @!attribute [r] other
            #   @return [Hash]
            #
            attr_reader :other

            ##
            # @param other [Hash]
            # @return [void]
            #
            def initialize(other:)
              @other = other
            end

            ##
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base, nil]
            #
            def call
              case other
              when ::Hash
                cast_hash(other)
              end
            end

            private

            ##
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base]
            #
            def cast_hash(hash)
              case hash[:scope]
              when :instance
                Entities::Callers::Instance.new(entity: hash[:entity])
              when :class
                Entities::Callers::Class.new(entity: hash[:entity])
              end
            end
          end
        end
      end
    end
  end
end
