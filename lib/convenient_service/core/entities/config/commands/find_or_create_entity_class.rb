# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Commands
          class FindOrCreateEntityClass < Support::Command
            include Support::Delegate

            ##
            # @!attribute [r] config
            #   @return [Class]
            #
            attr_reader :config

            ##
            # @!attribute [r] name
            #   @return [Symbol]
            #
            attr_reader :name

            ##
            # @return [Class]
            #
            delegate :klass, to: :config

            ##
            # @param config [Class]
            # @param name [Symbol]
            # @return [void]
            #
            def initialize(config:, name:)
              @config = config
              @name = name
            end

            ##
            # @return [Class]
            #
            def call
              Commands::FindEntityClass.call(config: config, name: name) || Commands::CreateEntityClass.call(config: config, name: name)
            end
          end
        end
      end
    end
  end
end
