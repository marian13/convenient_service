# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        class Middleware < Core::MethodChainMiddleware
          ##
          # NOTE: It is okish to assign to next method arguments here,
          # since splat for `args' and double splat for `kwargs'
          # always create new arrays and hashes respectively.
          #
          # NOTE: `raw' is NOT from Rails in this particular case, it is from HasResultSteps::Concern.
          #
          # rubocop:disable Rails/OutputSafety
          def next(*args, **kwargs, &block)
            return chain.next(*args, **kwargs, &block) unless args.first.instance_of?(::Symbol)

            kwargs[:in] = Utils::Array.wrap(kwargs[:in]) + [{method_name: raw(args.first)}, {organizer: :itself}]

            args[0] = args.first == :result ? Services::RunOwnMethodInOrganizer : Services::RunMethodInOrganizer

            chain.next(*args, **kwargs, &block)
          end
          # rubocop:enable Rails/OutputSafety

          private

          ##
          # TODO: `Plugins::HasResultSteps::Entities::Method.raw_value'.
          #
          def raw(object)
            Plugins::HasResultSteps::Entities::Method::Entities::Values::Raw.wrap(object)
          end
        end
      end
    end
  end
end
