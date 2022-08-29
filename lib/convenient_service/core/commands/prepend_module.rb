# frozen_string_literal: true

module ConvenientService
  module Core
    module Commands
      class PrependModule < Support::Command
        attr_reader :container, :scope, :mod

        def initialize(**kwargs)
          @container = kwargs.fetch(:container)
          @scope = kwargs.fetch(:scope)
          @mod = kwargs.fetch(:module)
        end

        def call
          case scope
          when :instance
            container.prepend mod
          when :class
            container.singleton_class.prepend mod
          end
        end
      end
    end
  end
end
