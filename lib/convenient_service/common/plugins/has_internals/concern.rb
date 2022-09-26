# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Concern
          include Support::Concern

          instance_methods do
            def internals
              @internals ||= self.class.internals_class.new
            end
          end

          class_methods do
            def internals_class
              ##
              # TODO: Generic `CreateInternalsClass`.
              #
              @internals_class ||= Commands::CreateInternalsClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
