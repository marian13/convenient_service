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
              when Entities::Callers::Base
                cast_caller(other)
              end
            end

            private

            ##
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base, nil]
            #
            def cast_hash(hash)
              return unless hash[:scope]
              return unless hash[:entity]

              case hash[:scope]
              when :instance
                Entities::Callers::Instance.new(entity: hash[:entity])
              when :class
                Entities::Callers::Class.new(entity: hash[:entity])
              end
            end

            ##
            # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Callers::Base, nil]
            #
            def cast_caller(caller)
              caller.copy
            end
          end
        end
      end
    end
  end
end
