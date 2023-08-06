# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            #
            # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart]
            #
            def mermaid_flowchart
              Entities::Flowchart.new(service: self)
            end
          end
        end
      end
    end
  end
end
