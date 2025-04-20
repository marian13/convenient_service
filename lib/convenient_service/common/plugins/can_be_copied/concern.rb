# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CanBeCopied
        module Concern
          include Support::Concern

          ##
          # @internal
          #   NOTE: `CanBeCopied` plugin expects that `CachesConstructorArguments` plugin is already used.
          #   That is why `constructor_arguments` method is available.
          #
          instance_methods do
            include Support::Copyable

            ##
            # @return [Array<Object>]
            #
            def to_args
              constructor_arguments.args
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def to_kwargs
              constructor_arguments.kwargs
            end

            ##
            # @return [Proc, nil]
            #
            def to_block
              constructor_arguments.block
            end

            ##
            # @return [ConvenientService::Support::Arguments]
            #
            def to_arguments
              constructor_arguments
            end
          end
        end
      end
    end
  end
end
