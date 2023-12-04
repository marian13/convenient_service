# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @param name [String, Symbol]
            # @param body [Proc, nil]
            # @return [String, Symbol]
            #
            def entry(name, &body)
              Commands::DefineEntry.call(feature_class: self, name: name, body: body)
            end
          end
        end
      end
    end
  end
end
