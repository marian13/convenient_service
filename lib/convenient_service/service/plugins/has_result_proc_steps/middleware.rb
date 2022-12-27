# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultProcSteps
        class Middleware < Core::MethodChainMiddleware
          ##
          # @internal
          #   NOTE: It is okish to assign to next method arguments here,
          #   since splat for `args` and double splat for `kwargs`
          #   always create new arrays and hashes respectively.
          #   https://github.com/ruby/spec/blob/c7ed8478a031d0df346d222495f4b4bbb298523b/language/keyword_arguments_spec.rb#L100
          #
          def next(*args, **kwargs, &block)
            args[0] = args.first.call if args.first.instance_of?(::Proc)

            chain.next(*args, **kwargs, &block)
          end
        end
      end
    end
  end
end
