# frozen_string_literal: true

module ConvenientService
  module Support
    module Copyable
      ##
      # @example
      #   person = Person.new('John', 'Doe', age: 42, gender: :male) do |p|
      #     puts p
      #   end
      #
      #   copy = person.copy
      #   copy = person.copy(overrides: {args: ['Jane']})
      #   copy = person.copy(overrides: {args: {0 => 'Jane'}})
      #   copy = person.copy(overrides: {kwargs: {age: 18}})
      #   copy = person.copy(overrides: {block: proc { |p| print p }})
      #
      # NOTE: Inline logic instead of private methods is used intentionally in order to NOT pollute the public interface.
      # NOTE: This method is NOT likely to be ever changed, that is why inline logic is preferred over command classes in this particular case.
      #
      def copy(overrides: {})
        overrides[:args] ||= {}
        overrides[:kwargs] ||= {}

        ##
        # TODO: Refactor runtime `respond_to?`. Investigate before refactoring.
        #
        args =
          if respond_to?(:to_args)
            case overrides[:args]
            when ::Array
              overrides[:args]
            when ::Hash
              Utils::Array.merge(to_args, overrides[:args])
            end
          else
            []
          end

        kwargs =
          if respond_to?(:to_kwargs)
            to_kwargs.merge(overrides[:kwargs])
          else
            {}
          end

        block =
          if respond_to?(:to_block)
            overrides[:block] || to_block
          end

        self.class.new(*args, **kwargs, &block)
      end
    end
  end
end
