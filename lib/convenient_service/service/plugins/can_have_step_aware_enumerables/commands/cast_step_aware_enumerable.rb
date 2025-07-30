# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Commands
          class CastStepAwareEnumerable < Support::Command
            ##
            # @!attribute [r] object
            #   @return [Object] Can be any type.
            #
            attr_reader :object

            ##
            # @!attribute [r] organizer
            #   @return [ConvenientService::Service]
            #
            attr_reader :organizer

            ##
            # @!attribute [r] propagated_result
            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            #
            attr_reader :propagated_result

            ##
            # @param object [Object] Can be any type.
            # @param organizer [ConvenientService::Service]
            # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            # @return [void]
            #
            def initialize(object:, organizer:, propagated_result: nil)
              @object = object
              @organizer = organizer
              @propagated_result = propagated_result
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable]
            #
            def call
              ::ConvenientService.raise Exceptions::ObjectIsNotEnumerable.new(object: object) unless object.is_a?(::Enumerable)

              Entities::StepAwareEnumerables::Enumerable.new(object: object, organizer: organizer, propagated_result: propagated_result)
            end
          end
        end
      end
    end
  end
end
