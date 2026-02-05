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
                    class Many < Base
                      ##
                      # @return [Boolean]
                      #
                      def many?
                        true
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [Hash{Symbol => Object}, nil]
                      # @note Throws `:propagated_result` when status is `error`.
                      #
                      def create_service_aware_iteration_block_value(result)
                        if success?(result)
                          data(result).to_h
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
                      def modify_to_result_with_none_keys(result)
                        none_from(result)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param keys [Array<Symbol>]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_only_keys(result, keys)
                        return none_from(result) if keys.none?

                        return keys.one? ? one_from(result) : many_from(result) unless success?(result)

                        old_data = data(result)
                        new_data = keys.each_with_object({}) { |key, new_data| new_data[key] = old_data.__fetch__(key) { raise_not_existing_only_key(key) } }

                        new_data.one? ? one_from(result, new_data) : many_from(result, new_data)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_all_keys(result)
                        result
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param keys [Array<Symbol>]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_except_keys(result, keys)
                        return result if keys.none?
                        return result unless success?(result)

                        old_data = data(result)

                        extra_keys = keys - old_data.__keys__

                        raise_not_existing_except_key(extra_keys.first) if extra_keys.any?

                        new_data = (old_data.__keys__ - keys).each_with_object({}) { |key, new_data| new_data[key] = old_data[key] }

                        many_from(result, new_data)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param values [Hash{Symbol => Object}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_extra_keys(result, values)
                        return result if values.none?
                        return result unless success?(result)

                        old_data = data(result)
                        new_data = old_data.to_h.merge(values)

                        many_from(result, new_data)
                      end

                      ##
                      # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      # @param renamings [Hash{Symbol => Symbol}]
                      # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                      #
                      def modify_to_result_with_renamed_keys(result, renamings)
                        return result if renamings.none?
                        return result unless success?(result)

                        old_data = data(result)

                        new_data =
                          old_data.__keys__
                            .each_with_object({}) { |key, namings| namings[key] = key }
                            .merge(renamings)
                            .each_with_object({}) { |(old_key, new_key), new_data| new_data[new_key] = old_data.__fetch__(old_key) { raise_not_existing_rename_key(old_key, new_key) } }

                        many_from(result, new_data)
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
