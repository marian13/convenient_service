# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # A wrapper for Ruby's stdlib `::Forwardable' module.
    # https://ruby-doc.org/stdlib-2.5.1/libdoc/forwardable/rdoc/Forwardable.html
    #
    # Tries to follow Rails `delegate' interface.
    # https://api.rubyonrails.org/classes/Module.html#method-i-delegate
    #
    module Delegate
      include Support::Concern

      included do
        extend ::Forwardable

        extend ClassMethodsForForwardable
      end

      ##
      # `ClassMethods' is loaded faster than `included' by `Concern'.
      # Since `Forwardable' has it own `delegate' - a different name is used.
      #
      module ClassMethodsForForwardable
        def delegate(*methods, to:)
          ##
          # NOTE: The following condition will NOT ever change. That is why it is inlined.
          #
          receiver =
            if to == :class
              :"self.class"
            else
              to
            end

          def_delegators receiver, *methods
        end
      end
    end
  end
end
