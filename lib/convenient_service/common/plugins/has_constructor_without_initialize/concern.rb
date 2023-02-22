# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasConstructorWithoutInitialize
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Object]
            # @since 0.2.0
            #
            # @internal
            #   NOTE: `allocate` creates an uninitialized object and allocates memory for it.
            #
            #   NOTE: Pseudocode for default `new` implementation.
            #     def new
            #       instance = allocate
            #
            #       instance.send(:initialize)
            #
            #       instance
            #     end
            #
            #   NOTE: Code for `new_without_initialize`.
            #     def new_without_initialize
            #       allocate
            #     end
            #
            #   NOTE: `create` is used instead of `new` in order to avoid the accidental feeling that `new_without_initialize` is Ruby's built-in method.
            #
            #   NOTE: Check the following links for more info.
            #   - https://ruby-doc.org/core-2.5.0/Class.html#method-i-allocate
            #   - https://frontdeveloper.pl/2018/11/ruby-allocate-method/
            #
            def create_without_initialize
              allocate
            end
          end
        end
      end
    end
  end
end
