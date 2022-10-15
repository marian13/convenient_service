# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module NormalizesEnv
        ##
        # - Single splat `*` converts `nil` to empty array.
        # - Double splat `**` raises on `nil`.
        # - Umpersand `&` converts `nil` to `nil`.
        #
        # The following middleware converts `env[:kwargs]` to a hash.
        # This way `stack.call(*env[:args], **env[:kwargs], &env[:block])` won't fail even if a user passes `nil` as `kwargs`.
        #
        # Check the following link for more details:
        # - https://bugs.ruby-lang.org/issues/8507
        #
        class Middleware < Core::ClassicMiddleware
          def call(env = nil)
            env = env.to_h
            env = env.merge(args: env[:args].to_a, kwargs: env[:kwargs].to_h, block: env[:block])

            stack.call(env)
          end
        end
      end
    end
  end
end
