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
                      # @return [Hash{Symbol => Object}]
                      #
                      def data_all_key_values(result)
                        result.unsafe_data.to_h
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Object] Can be any type.
                      #
                      def data_first_value(result)
                        _, value = result.unsafe_data.to_h.first

                        value
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
                      def none_from(result, data = result.unsafe_data)
                        result.copy(overrides: {kwargs: {data: data, key_mode: Entities::KeyModes.none}})
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

                      ##
                      # @param key [Symbol]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly]
                      #
                      def raise_not_existing_only_key(key)
                        ::ConvenientService.raise Exceptions::NotExistingAttributeForOnly.new(key: key)
                      end

                      ##
                      # @param key [Symbol]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept]
                      #
                      def raise_not_existing_except_key(key)
                        ::ConvenientService.raise Exceptions::NotExistingAttributeForExcept.new(key: key)
                      end

                      ##
                      # @param key [Symbol]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename]
                      #
                      def raise_not_existing_rename_key(key, renamed_key)
                        ::ConvenientService.raise Exceptions::NotExistingAttributeForRename.new(key: key, renamed_key: renamed_key)
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
