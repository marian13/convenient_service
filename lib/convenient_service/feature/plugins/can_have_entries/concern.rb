# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [Object] Can be any type.
            #
            def entry(...)
              public_send(...)
            end
          end

          class_methods do
            ##
            # @param names [Array<String, Symbol>]
            # @param body [Proc, nil]
            # @return [Array<String, Symbol>]
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
