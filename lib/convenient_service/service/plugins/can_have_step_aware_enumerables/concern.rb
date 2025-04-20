# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @api public
            #
            # @param object [Object] Can be any type.
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable]
            #
            def step_aware_enumerable(object)
              Commands::CastStepAwareEnumerable.call(object: object, organizer: self)
            end

            ##
            # @api public
            #
            # @param object [Object] Can be any type.
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerator]
            #
            def step_aware_enumerator(object)
              Commands::CastStepAwareEnumerator.call(object: object, organizer: self)
            end
          end
        end
      end
    end
  end
end
