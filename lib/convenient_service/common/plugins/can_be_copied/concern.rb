# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanBeCopied
        module Concern
          include Support::Concern

          ##
          # NOTE: `CanBeCopied` plugin expects that `CachesConstructorArguments` plugin is already used.
          # That is why `constructor_arguments` method is available.
          #
          instance_methods do
            include Support::Copyable

            def to_args
              constructor_arguments.args
            end

            def to_kwargs
              constructor_arguments.kwargs
            end

            def to_block
              constructor_arguments.block
            end
          end
        end
      end
    end
  end
end
