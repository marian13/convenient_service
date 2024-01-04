# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @param names [Array<String, Symbol>]
            # @param body [Proc, nil]
            # @return [String, Symbol]
            #
            def entry(*names, &body)
              Commands::DefineEntries.call(feature_class: self, names: names, body: body)
            end
          end
        end
      end
    end
  end
end
