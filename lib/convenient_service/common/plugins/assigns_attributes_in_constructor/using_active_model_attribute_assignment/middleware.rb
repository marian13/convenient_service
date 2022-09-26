# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module AssignsAttributesInConstructor
        module UsingActiveModelAttributeAssignment
          class Middleware < Core::MethodChainMiddleware
            ##
            # TODO: Consider creation of a plugin that assigns `*args` with `assign_attributes` as well, not only `**kwargs`.
            # Check `Method#parameters` for a possible solution.
            # https://ruby-doc.org/core-3.1.0/Method.html#method-i-parameters
            #
            def next(*args, **kwargs, &block)
              chain.next(*args, **kwargs, &block)

              ##
              # NOTE: `assign_attributes` expects `attr_writer` for all `kwargs` keys.
              #
              # https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-assign_attributes
              #
              entity.assign_attributes(kwargs)
            end
          end
        end
      end
    end
  end
end
