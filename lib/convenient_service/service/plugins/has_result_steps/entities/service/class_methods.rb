# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Service
            module ClassMethods
              def cast(other)
                case other
                when ::Class then cast_klass(other)
                when Service then cast_service(other)
                end
              end

              private

              def cast_klass(klass)
                new(klass)
              end

              def cast_service(service)
                new(service.klass)
              end
            end
          end
        end
      end
    end
  end
end
