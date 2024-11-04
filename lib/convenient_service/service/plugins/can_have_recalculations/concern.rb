# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveRecalculations
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [ConvenientService::Service]
            #
            def recalculate
              copy
            end
          end
        end
      end
    end
  end
end
