# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Caller
            module Commands
              class ResolveSuperMethod < Support::Command
                ##
                # @!attribute [r] entity
                #   @return [Object, Class]
                #
                attr_reader :entity

                ##
                # @!attribute [r] scope
                #   @return [:instance, :class]
                #
                attr_reader :scope

                ##
                # @!attribute [r] method
                #   @return [Symbol]
                #
                attr_reader :method

                def initialize(entity:, scope:, method:)
                  @entity = entity
                  @scope = scope
                  @method = method
                end

                ##
                # @return [Method]
                #
                def call
                  case scope
                  when :class
                    entity.commit_config!

                    ancestors = entity.singleton_class.ancestors

                    methods_middlewares_callers = entity::ClassMethodsMiddlewaresCallers
                  when :instance
                    entity.class.commit_config!

                    ancestors = entity.class.ancestors

                    methods_middlewares_callers = entity.class::InstanceMethodsMiddlewaresCallers
                  end

                  ancestors
                    .then { |ancestors| Utils::Array.drop_while(ancestors, inclusively: true) { |ancestor| ancestor != methods_middlewares_callers } }
                    .find { |ancestor| Utils::Module.has_own_instance_method?(ancestor, method, private: true) }
                    .then { |ancestor| Utils::Module.get_own_instance_method(ancestor, method, private: true) }
                    .bind(entity)
                end
              end
            end
          end
        end
      end
    end
  end
end
