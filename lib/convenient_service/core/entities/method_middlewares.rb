# frozen_string_literal: true

require_relative "method_middlewares/commands"
require_relative "method_middlewares/entities"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        def initialize(**kwargs)
          @stack = Entities::Stack.new(**kwargs)
        end

        ##
        #
        #
        def configure(&configuration_block)
          stack.instance_exec(&configuration_block)
        end

        ##
        #
        #
        def define!
          Commands::DefineCaller.call(stack: stack)
        end

        ##
        # TODO: Simplify.
        #
        def call(env, original)
          stack.dup.use(original).call(env)
        end

        ##
        #
        #
        def to_a
          stack.to_a.map(&:first)
        end

        private

        attr_reader :stack
      end
    end
  end
end
