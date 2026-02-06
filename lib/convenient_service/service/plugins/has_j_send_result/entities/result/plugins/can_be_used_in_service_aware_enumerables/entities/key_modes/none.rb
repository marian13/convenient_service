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
                    class None < Base
                      ##
                      # @return [Boolean]
                      #
                      def none?
                        true
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Boolean]
                      # @note Throws `:propagated_result` when status is `error`.
                      #
                      def create_service_aware_iteration_block_value(result)
                        return true if success?(result)
                        return false if failure?(result)

                        propagate_result(result)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_none_keys(result)
                        result
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param keys [Array<Symbol>]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly]
                      #
                      def modify_to_result_with_only_keys(result, keys)
                        keys.none? ? result : raise_not_existing_only_key(keys.first)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_all_keys(result)
                        many_from(result)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param keys [Array<Symbol>]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept]
                      #
                      def modify_to_result_with_except_keys(result, keys)
                        keys.none? ? many_from(result) : raise_not_existing_except_key(keys.first)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param values [Hash{Symbol => Object}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_extra_keys(result, values)
                        values.none? ? many_from(result) : many_from(result, values)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param renamings [Hash{Symbol => Symbol}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename]
                      #
                      def modify_to_result_with_renamed_keys(result, renamings)
                        return result if renamings.none?

                        key, renamed_key = renamings.first

                        raise_not_existing_rename_key(key, renamed_key)
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
