# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [Object] Can be any type.
            #
            def trigger(...)
              public_send(...)
            end
          end

          class_methods do
            ##
            # @param names [Array<String, Symbol>]
            # @param body [Proc, nil]
            # @return [Array<String, Symbol>]
            #
            def entry(*names, &body)
              Commands::DefineEntries.call(feature_class: self, names: names, body: body)
            end

            ##
            # @return [Object] Can be any type.
            #
            def trigger(...)
              new.trigger(...)
            end
          end
        end
      end
    end
  end
end
