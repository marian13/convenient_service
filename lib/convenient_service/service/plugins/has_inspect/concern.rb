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
              "<#{inspect_values[:name]}>"
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def inspect_values
              {name: Utils::Class.display_name(self.class)}
            end
          end
        end
      end
    end
  end
end
