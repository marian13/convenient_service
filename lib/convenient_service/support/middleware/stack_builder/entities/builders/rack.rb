# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Entities
          module Builders
            class Rack < Builders::Custom
              ##
              # @param env [Hash{Symbol => Object}]
              # @param original [Proc]
              # @return [Object] Can be any type.
              #
              # @internal
              #   TODO: Direct specs.
              #
              def call_with_original(env, original)
                dup.use(Custom::Entities::ProcWithNew.new(original)).call(env)
              end

              ##
              # @param env [Hash{Symbol => Object}]
              # @return [Object] Can be any type.
              #
              # @see https://github.com/rack/rack/blob/v3.1.7/lib/rack/builder.rb#L268
              # @see https://github.com/Ibsciss/ruby-middleware/blob/v0.4.2/lib/middleware/runner.rb#L7
              #
              # @internal
              #   NOTE: When stack is empty - `env` is returned. Just like `ruby-middleware` does.
              #   NOTE: `reduce` for empty array returns initial value.
              #
              #   TODO: Direct specs.
              #
              def call(env)
                return env if stack.empty?

                app =
                  stack
                    .map { |middleware| proc { |app| middleware.new(app) } }
                    .reverse
                    .reduce(Custom::Constants::INITIAL_MIDDLEWARE) { |a, e| e[a] }

                app.call(env)
              end
            end
          end
        end
      end
    end
  end
end
