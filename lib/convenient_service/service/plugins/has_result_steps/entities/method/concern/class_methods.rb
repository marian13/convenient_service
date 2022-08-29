# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Concern
              module ClassMethods
                def cast(other, **options)
                  Commands::CastMethod.call(other: other, options: options)
                end
              end
            end
          end
        end
      end
    end
  end
end
