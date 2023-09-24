require "yard"

##
# This file is used to allow parsing of yard docs inside `included`, `instance_methods` and `class_methods` blocks.
#
# It is loaded by the `RUBYLIB` ENV variable passed to `task docs:generate` in `Taskfile`.
#
# @see https://rubydoc.info/gems/yard/file/docs/GettingStarted.md#plugin-support
# @see https://github.com/digitalcuisine/yard-activesupport-concern
# @see https://github.com/digitalcuisine/yard-activesupport-concern/blob/v0.0.1/lib/yard-activesupport-concern.rb
# @see https://stackoverflow.com/a/901109/12201472
#
module YARD
  module Concern
    class IncludedHandler < YARD::Handlers::Ruby::Base
      handles method_call(:included)

      namespace_only

      def process
        parse_block(statement.last.last, namespace: namespace, scope: :instance)
      end
    end

    class InstanceMethodsHandler < YARD::Handlers::Ruby::Base
      handles method_call(:instance_methods)

      namespace_only

      def process
        parse_block(statement.last.last, namespace: namespace, scope: :instance)
      end
    end

    class ClassMethodsHandler < YARD::Handlers::Ruby::Base
      handles method_call(:class_methods)

      namespace_only

      def process
        parse_block(statement.last.last, namespace: namespace, scope: :class)
      end
    end
  end
end
