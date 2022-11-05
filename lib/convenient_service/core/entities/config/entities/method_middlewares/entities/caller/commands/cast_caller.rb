# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Caller
                module Commands
                  class CastCaller < Support::Command
                    ##
                    # @!attribute [r] other
                    #   @return [Hash]
                    #
                    attr_reader :other

                    ##
                    # @param other [Hash, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller]
                    # @return [void]
                    #
                    def initialize(other:)
                      @other = other
                    end

                    ##
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller, nil]
                    #
                    def call
                      case other
                      when ::Hash
                        cast_hash(other)
                      when Caller
                        cast_caller(other)
                      end
                    end

                    private

                    ##
                    # @param hash [Hash]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller, nil]
                    #
                    def cast_hash(hash)
                      return unless hash[:scope]

                      case hash[:scope]
                      when :instance
                        Caller.new(prefix: Caller::INSTANCE_PREFIX)
                      when :class
                        Caller.new(prefix: Caller::CLASS_PREFIX)
                      end
                    end

                    ##
                    # @param caller [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller]
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
      end
    end
  end
end
