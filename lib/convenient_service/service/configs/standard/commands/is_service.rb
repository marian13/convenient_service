# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Configs
      module Standard
        module Commands
          class IsService < Support::Command
            ##
            # @!attribute [r] service
            #   @return [Object] Can be any type.
            #
            attr_reader :service

            ##
            # @param service [Object] Can be any type.
            # @return [void]
            #
            def initialize(service:)
              @service = service
            end

            ##
            # @return [Boolean]
            #
            def call
              Commands::IsServiceClass[service_class: service.class]
            end
          end
        end
      end
    end
  end
end
