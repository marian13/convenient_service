# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConfig
        module Concern
          include Support::Concern

          instance_methods do
            include Support::Delegate

            delegate :config, to: :class
          end

          class_methods do
            def config
              @config ||= superclass.respond_to?(:config) ? superclass.config.dup : Entities::ReadOnlyConfig.new
            end

            def configure(&block)
              @config = config.to_read_default_write_config.tap(&block).to_read_only_config
            end
          end
        end
      end
    end
  end
end
