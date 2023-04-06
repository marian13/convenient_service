# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Entry
        include Support::Concern

        class_methods do
          ##
          # @param name [String, Symbol]
          # @param body [Proc]
          # @return [String, Symbol]
          #
          def entry(name, &body)
            Commands::DefineEntry.call(container: self, name: name, body: body)
          end
        end
      end
    end
  end
end
