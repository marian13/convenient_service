# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Caller
                module Concern
                  module InstanceMethods
                    include Support::Copyable

                    ##
                    # @!attribute [r] prefix
                    #   @return [String]
                    #
                    attr_reader :prefix

                    ##
                    # @param prefix [String]
                    # @return [void]
                    #
                    def initialize(prefix:)
                      @prefix = prefix
                    end

                    ##
                    # @param scope [:instance, :class]
                    # @param method [Symbol]
                    # @param container [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    # @return [Boolean]
                    #
                    def define_method_callers!(scope, method, container)
                      Commands::DefineMethodCallers.call(scope: scope, method: method, container: container, caller: self)
                    end

                    ##
                    # @param other [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller, Object]
                    # @return [Boolean]
                    #
                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if prefix != other.prefix

                      true
                    end

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def to_kwargs
                      to_arguments.kwargs
                    end

                    ##
                    # @return [ConvenientService::Support::Arguments]
                    #
                    def to_arguments
                      Support::Arguments.new(prefix: prefix)
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
