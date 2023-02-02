# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasInspect
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [String]
            # @since 0.2.0
            #
            def inspect
              "<#{self.class.name}>"
            end
          end
        end
      end
    end
  end
end
