# frozen_string_literal: true

# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            module Commands
              class CastContainer < Support::Command
                ##
                # @!attribute [r] other
                #   @return [Hash]
                #
                attr_reader :other

                ##
                # @param other [Hash, ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                # @return [void]
                #
                def initialize(other:)
                  @other = other
                end

                ##
                # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container, nil]
                #
                def call
                  case other
                  when ::Hash
                    cast_hash(other)
                  when Container
                    cast_container(other)
                  end
                end

                private

                ##
                # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container, nil]
                #
                def cast_hash(hash)
                  return unless hash[:scope]
                  return unless hash[:klass]

                  case hash[:scope]
                  when :instance
                    Container.new(klass: hash[:klass])
                  when :class
                    Container.new(klass: hash[:klass].singleton_class)
                  end
                end

                ##
                # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                #
                def cast_container(container)
                  container.copy
                end
              end
            end
          end
        end
      end
    end
  end
end
