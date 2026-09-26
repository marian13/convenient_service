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
          class BuildEntityFromConfigOption < Support::Command
            ##
            # @!attribute [r] base_entity
            #   @return [#with]
            #
            attr_reader :base_entity

            ##
            # @!attribute [r] config
            #   @return [ConvenientService::Config::Entities::Option]
            #
            attr_reader :option

            ##
            # @!attribute [r] detail_keys
            #   @return [Array<Symbol>]
            #
            attr_reader :detail_keys

            ##
            # @param base_entity [#with]
            # @param option [ConvenientService::Config::Entities::Option]
            # @param detail_keys [Array<Symbol>]
            # @return [void]
            #
            def initialize(base_entity:, option:, detail_keys:)
              @base_entity = base_entity
              @option = option
              @detail_keys = detail_keys
            end

            ##
            # @return [Object] Can be any type.
            #
            def call
              return base_entity unless option
              return base_entity if option.data.empty?
              return base_entity if detail_keys.empty?

              data_values = option.data.slice(*detail_keys)

              return base_entity if data_values.empty?

              base_entity.with(**data_values)
            end
          end
        end
      end
    end
  end
end
