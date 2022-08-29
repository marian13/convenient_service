# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Error
          class Middleware < Core::MethodChainMiddleware
            def next(*args, **kwargs)
              Commands::AssertEitherArgsOrKwargsArePassed.call(args: args, kwargs: kwargs)

              return chain.next(**kwargs) if kwargs.any?

              Commands::AssertArgsCountLowerThanThree.call(args: args)

              return chain.next if args.none?

              return chain.next(message: args.first) if args.one?

              chain.next(message: args.first, code: args.last) # NOTE: if args.count == 2
            end
          end
        end
      end
    end
  end
end
