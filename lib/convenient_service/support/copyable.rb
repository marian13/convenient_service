# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
      # @internal
      #   NOTE: Inline logic instead of private methods is used intentionally in order to NOT pollute the public interface.
      #   NOTE: This method is NOT likely to be ever changed, that is why inline logic is preferred over command classes in this particular case.
      #
      #   NOTE: The `respond_to` solution was slower by 16%. Check this file history to review the previous implementation. Use the `empty_service` benchmark to compare.
      #
      def copy(overrides: {})
        args =
          if overrides.has_key?(:args)
            overrides[:args].instance_of?(::Hash) ? Utils::Array.merge(to_arguments.args, overrides[:args]) : overrides[:args]
          else
            to_arguments.args
          end

        kwargs =
          if overrides.has_key?(:kwargs)
            overrides[:kwargs].instance_of?(::Array) ? overrides[:kwargs].first : to_arguments.kwargs.merge(overrides[:kwargs])
          else
            to_arguments.kwargs
          end

        block = overrides.fetch(:block) { to_arguments.block }

        self.class.new(*args, **kwargs, &block)
      end
    end
  end
end
