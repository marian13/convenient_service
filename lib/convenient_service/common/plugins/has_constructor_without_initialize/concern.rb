# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module HasConstructorWithoutInitialize
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Object]
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
            #   NOTE: Check the following links for more info.
            #   - https://ruby-doc.org/core-2.5.0/Class.html#method-i-allocate
            #   - https://frontdeveloper.pl/2018/11/ruby-allocate-method/
            #
            def new_without_initialize
              allocate
            end
          end
        end
      end
    end
  end
end
