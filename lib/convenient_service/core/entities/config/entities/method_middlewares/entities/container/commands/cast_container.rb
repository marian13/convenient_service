# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
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
                    # @param other [Hash, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    # @return [void]
                    #
                    def initialize(other:)
                      @other = other
                    end

                    ##
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container, nil]
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
                    # @param hash [Hash]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container, nil]
                    #
                    def cast_hash(hash)
                      return unless hash[:scope]
                      return unless hash[:klass]
                      return unless hash[:klass].is_a?(Class)

                      case hash[:scope]
                      when :instance
                        Container.new(klass: hash[:klass])
                      when :class
                        Container.new(klass: hash[:klass].singleton_class)
                      end
                    end

                    ##
                    # @param container [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
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
  end
end
