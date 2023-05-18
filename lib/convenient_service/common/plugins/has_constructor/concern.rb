# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConstructor
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [void]
            #
            def initialize(...)
            end
          end

          class_methods do
            ##
            # @return [Object] Can be any type.
            #
            def new(...)
              new_without_commit_config(...)
            end
          end
        end
      end
    end
  end
end
