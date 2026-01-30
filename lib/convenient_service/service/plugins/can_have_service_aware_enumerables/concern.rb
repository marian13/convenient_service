# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveServiceAwareEnumerables
        module Concern
          include Support::Concern

          ##
          # TODO: Implement in `CanBeUsedInStepAwareEnumerables`.
          #
          # class_methods do
          #   def to_service_aware_iteration_block_value
          #   end
          # end
          ##

          instance_methods do
            ##
            # @api public
            #
            # @param object [Object] Can be any type.
            # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
            # @raise [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Exceptions::ObjectIsNotEnumerable]
            #
            def service_aware_enumerable(object)
              Commands::CastServiceAwareEnumerable.call(object: object, organizer: self)
            end

            ##
            # @api public
            #
            # @param object [Object] Can be any type.
            # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
            # @raise [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Exceptions::ObjectIsNotEnumerator]
            #
            def service_aware_enumerator(object)
              Commands::CastServiceAwareEnumerator.call(object: object, organizer: self)
            end
          end
        end
      end
    end
  end
end
