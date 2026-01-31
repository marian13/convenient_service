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
                        if success?(result)
                          true
                        elsif failure?(result)
                          false
                        else
                          propagate_result(result)
                        end
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
                      #
                      def modify_to_result_with_only_keys(result, keys)
                        return result if keys.none?

                        raise_not_existing_attribute_exception(result, keys.first)
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
                      #
                      def modify_to_result_with_except_keys(result, keys)
                        return many_from(result) if keys.none?

                        raise_not_existing_attribute_exception(result, keys.first)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param values [Hash{Symbol => Object}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_extra_keys(result, values)
                        return many_from(result) if values.none?

                        many_from(result, values)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param renamings [Hash{Symbol => Symbol}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_renamed_keys(result, renamings)
                        return result if renamings.none?

                        raise_not_existing_attribute_exception(result, renamings.first.first)
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
