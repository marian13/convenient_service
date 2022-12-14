# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultMethodSteps
        class Middleware < Core::MethodChainMiddleware
          ##
          # @internal
          #   NOTE: It is okish to assign to next method arguments here,
          #   since splat for `args` and double splat for `kwargs`
          #   always create new arrays and hashes respectively.
          #   https://github.com/ruby/spec/blob/c7ed8478a031d0df346d222495f4b4bbb298523b/language/keyword_arguments_spec.rb#L100
          #
          def next(*args, **kwargs, &block)
            return chain.next(*args, **kwargs, &block) unless args.first.instance_of?(::Symbol)

            kwargs[:in] = Utils::Array.wrap(kwargs[:in]) + [{method_name: raw(args.first)}, {organizer: :itself}]

            args[0] = (args.first == :result) ? Services::RunOwnMethodInOrganizer : Services::RunMethodInOrganizer

            chain.next(*args, **kwargs, &block)
          end

          private

          def raw(object)
            Support::RawValue.wrap(object)
          end
        end
      end
    end
  end
end
