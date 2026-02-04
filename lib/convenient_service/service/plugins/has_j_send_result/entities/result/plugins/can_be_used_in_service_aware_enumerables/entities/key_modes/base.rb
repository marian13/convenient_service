# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeUsedInServiceAwareEnumerables
                module Entities
                  module KeyModes
                    class Base
                      ##
                      # @return [Boolean]
                      #
                      def none?
                        false
                      end

                      ##
                      # @return [Boolean]
                      #
                      def one?
                        false
                      end

                      ##
                      # @return [Boolean]
                      #
                      def many?
                        false
                      end

                      private

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Boolean]
                      #
                      def success?(result)
                        result.status.unsafe_success?
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Boolean]
                      #
                      def failure?(result)
                        result.status.unsafe_failure?
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Boolean]
                      #
                      def data(result)
                        result.unsafe_data
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [void]
                      # @note Throws `:propagated_result`.
                      #
                      def propagate_result(result)
                        throw :propagated_result, {propagated_result: result}
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def none_from(result)
                        result.copy(overrides: {kwargs: {data: {}, key_mode: Entities::KeyModes.none}})
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param data [Hash{Symbol => Object}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def one_from(result, data = result.unsafe_data)
                        result.copy(overrides: {kwargs: {data: data, key_mode: Entities::KeyModes.one}})
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param data [Hash{Symbol => Object}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def many_from(result, data = result.unsafe_data)
                        result.copy(overrides: {kwargs: {data: data, key_mode: Entities::KeyModes.many}})
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
