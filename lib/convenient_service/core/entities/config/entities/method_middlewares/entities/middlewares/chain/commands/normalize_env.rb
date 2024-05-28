# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Chain < Middlewares::Base
                  module Commands
                    ##
                    # - Single splat `*` converts `nil` to empty array.
                    # - Double splat `**` raises on `nil`.
                    # - Umpersand `&` converts `nil` to `nil`.
                    #
                    # The following middleware converts `env[:kwargs]` to a hash.
                    # This way `__send__(:next, *env[:args], **env[:kwargs], &env[:block])` won't fail even if a user passes `nil` as `kwargs`.
                    #
                    # Check the following link for more details:
                    # - https://bugs.ruby-lang.org/issues/8507
                    #
                    class NormalizeEnv < Support::Command
                      ##
                      # @!attribute [r] env
                      #   @return [Hash, nil]
                      #
                      attr_reader :env

                      ##
                      # @param env [Hash, nil]
                      # @return [void]
                      #
                      def initialize(env:)
                        @env = env.to_h
                      end

                      ##
                      # @return [Hash]
                      #
                      def call
                        env.merge(args: env[:args].to_a, kwargs: env[:kwargs].to_h, block: env[:block])
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
