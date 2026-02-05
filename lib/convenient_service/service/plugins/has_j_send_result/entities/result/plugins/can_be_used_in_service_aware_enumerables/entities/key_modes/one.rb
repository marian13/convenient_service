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
                    class One < Base
                      ##
                      # @return [Boolean]
                      #
                      def one?
                        true
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Object, nil]
                      # @note Throws `:propagated_result` when status is `error`.
                      #
                      def create_service_aware_iteration_block_value(result)
                        if success?(result)
                          _, value = data(result).to_h.first

                          value
                        elsif failure?(result)
                          nil
                        else
                          propagate_result(result)
                        end
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
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_none_keys(result)
                        none_from(result)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param keys [Array<Symbol>]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForOnly]
                      #
                      def modify_to_result_with_only_keys(result, keys)
                        return none_from(result) if keys.none?

                        return keys.one? ? one_from(result) : many_from(result) unless success?(result)

                        old_data = data(result)

                        extra_keys = keys - old_data.__keys__

                        raise_not_existing_only_key(extra_keys.first) if extra_keys.any?

                        result
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param keys [Array<Symbol>]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForExcept]
                      #
                      def modify_to_result_with_except_keys(result, keys)
                        return many_from(result) if keys.none?
                        return many_from(result) unless success?(result)

                        old_data = data(result)

                        extra_keys = keys - old_data.__keys__

                        raise_not_existing_except_key(extra_keys.first) if extra_keys.any?

                        many_from(result, {})
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param values [Hash{Symbol => Object}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_extra_keys(result, values)
                        return many_from(result) if values.none?
                        return many_from(result) unless success?(result)

                        old_data = data(result)

                        new_data = old_data.to_h.merge(values)

                        many_from(result, new_data)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param renamings [Hash{Symbol => Symbol}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Exceptions::NotExistingAttributeForRename]
                      #
                      def modify_to_result_with_renamed_keys(result, renamings)
                        return result if renamings.none?
                        return result unless success?(result)

                        old_data = data(result)

                        extra_keys = renamings.keys - old_data.__keys__

                        key, renamed_key = renamings.first

                        raise_not_existing_rename_key(key, renamed_key) if extra_keys.any?

                        one_from(result, {renamed_key => old_data[key]})
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
