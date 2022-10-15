# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            module Commands
              class PrependModule < Support::Command
                include Support::Delegate

                ##
                # @!attribute [r] scope
                #   @return [:instance, :scope]
                #
                attr_reader :scope

                ##
                # @!attribute [r] container
                #   @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                #
                attr_reader :container

                ##
                # @!attribute [r] mod
                #   @return [Module]
                #
                attr_reader :mod

                ##
                # @return [Class]
                #
                delegate :service_class, to: :container

                ##
                # @param scope [:instance, :scope]
                # @param container [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                # @param mod [Module]
                # @return [void]
                #
                def initialize(scope:, container:, mod:)
                  @scope = scope
                  @container = container
                  @mod = mod
                end

                ##
                # @return [void]
                #
                def call
                  case scope
                  when :instance
                    service_class.prepend mod
                  when :class
                    service_class.singleton_class.prepend mod
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
