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
            class Stateful < Builders::Custom
              ##
              # @param kwargs [Hash{Symbol => Object}]
              # @return [void]
              #
              def initialize(**kwargs)
                super

                @index = -1
              end

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
              # @internal
              #   NOTE: When stack is empty - `env` is returned. Just like `ruby-middleware` does.
              #   NOTE: Once middleware backends are unified, consider to create new object to ensure thread-safety.
              #   NOTE: Once middleware backends are unified, move `stack.empty?` and `index == stack.size - 1` to entrypoint method.
              #
              #   TODO: Direct specs.
              #
              def call(env)
                self.index += 1

                return env if index == stack.size

                stack[index].new(self).call(env)
              ensure
                self.index = -1
              end

              private

              ##
              # @!attribute [r] index
              #   @return [Integer]
              #
              attr_accessor :index
            end
          end
        end
      end
    end
  end
end
