# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Concern
          module InstanceMethods
            def result
              raise Errors::ResultIsNotOverridden.new(service: self)
            end

            ##
            # TODO: Specs.
            #
            def success(**kwargs)
              self.class.success(**kwargs.merge(service: self))
            end

            def failure(**kwargs)
              self.class.failure(**kwargs.merge(service: self))
            end

            def error(**kwargs)
              self.class.error(**kwargs.merge(service: self))
            end
          end
        end
      end
    end
  end
end
