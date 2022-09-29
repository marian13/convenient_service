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

                attr_reader :scope, :container, :mod

                delegate :service_class, to: :container

                def initialize(scope:, container:, mod:)
                  @scope = scope
                  @container = container
                  @mod = mod
                end

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
