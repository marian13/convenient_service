# frozen_string_literal: true

require_relative "flowchart/entities"

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Entities
          class Flowchart
            ##
            # @api private
            #
            # @!attribute service [r]
            #   @return [ConvenientService::Service]
            #
            attr_reader :service

            ##
            # @api private
            #
            # @param service [ConvenientService::Service]
            # @return [void]
            #
            def initialize(service:)
              @service = service
            end

            ##
            # @api private
            #
            # @return [String]
            #
            def content
              template.render(**replacements)
            end

            ##
            # @api private
            #
            # @return [Hash{Symbol => Object}]
            #
            def replacements
              {
                title: settings.title,
                code: code.generate
              }
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Code]
            #
            def code
              @code ||= Entities::Code.new(flowchart: self)
            end

            ##
            # @api public
            #
            # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Settings]
            #
            def settings
              @settings ||= Entities::Settings.new(flowchart: self)
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Template]
            #
            def template
              @template ||= Entities::Template.new
            end

            ##
            # @api public
            #
            # @return [Boolean]
            #
            # @internal
            #   TODO: Specs for logger.
            #
            def save
              ::File.write(settings.absolute_path, content)
                .tap { ConvenientService.logger.info { "[HasMermaidFlowchart] Flowchart is saved into `#{settings.absolute_path}` " } }
            end

            ##
            # @api private
            #
            # @param other [Object]
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if service != other.service

              true
            end
          end
        end
      end
    end
  end
end
