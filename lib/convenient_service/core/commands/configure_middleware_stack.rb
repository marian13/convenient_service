# frozen_string_literal: true

module ConvenientService
  module Core
    module Commands
      class ConfigureMiddlewareStack < Support::Command
        attr_reader :stack, :block

        def initialize(stack:, block:)
          @stack = stack
          @block = block
        end

        def call
          stack.instance_exec(&block)
        end
      end
    end
  end
end
