# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module AssignsAttributesInConstructor
        module UsingActiveModelAttributeAssignment
          class Middleware < MethodChainMiddleware
            intended_for :initialize, entity: any_entity

            ##
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @return [void]
            #
            # @internal
            #   TODO: Consider creation of a plugin that assigns `*args` with `assign_attributes` as well, not only `**kwargs`.
            #   Check `Method#parameters` for a possible solution.
            #   - https://ruby-doc.org/core-3.1.0/Method.html#method-i-parameters
            #
            #   NOTE: `assign_attributes` expects `attr_writer` for all `kwargs` keys.
            #   - https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-assign_attributes
            #
            def next(*args, **kwargs, &block)
              chain.next(*args, **kwargs, &block)

              entity.assign_attributes(kwargs)
            end
          end
        end
      end
    end
  end
end
