# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanBeCopied
        module Concern
          include Support::Concern

          ##
          # NOTE: `CanBeCopied` plugin expects that `CachesConstructorParams` plugin is already used.
          # That is why `constructor_params` method is available.
          #
          instance_methods do
            include Support::Copyable

            def to_args
              constructor_params.args
            end

            def to_kwargs
              constructor_params.kwargs
            end

            def to_block
              constructor_params.block
            end
          end
        end
      end
    end
  end
end
