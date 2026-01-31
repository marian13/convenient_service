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
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api private
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeUsedInServiceAwareEnumerables::Entities::KeyModes::Base]
                    #
                    def key_mode
                      extra_kwargs[:key_mode] || Entities::KeyModes.many
                    end

                    ##
                    # @api public
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_all_keys
                      key_mode.modify_to_result_with_all_keys(self)
                    end

                    ##
                    # @api public
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_none_keys
                      key_mode.modify_to_result_with_none_keys(self)
                    end

                    ##
                    # @api public
                    # @param keys [Array<Symbol>]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_only_keys(*keys)
                      key_mode.modify_to_result_with_only_keys(self, keys)
                    end

                    ##
                    # @api public
                    # @param keys [Array<Symbol>]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_except_keys(*keys)
                      key_mode.modify_to_result_with_except_keys(self, keys)
                    end

                    ##
                    # @api public
                    # @param renamings [Hash{Symbol => Symbol}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_renamed_keys(**renamings)
                      key_mode.modify_to_result_with_renamed_keys(self, renamings)
                    end

                    ##
                    # @api public
                    # @param values [Hash{Symbol => Object}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_extra_keys(**values)
                      key_mode.modify_to_result_with_extra_keys(self, values)
                    end

                    ##
                    # @api private
                    # @return [Object] Can be any type.
                    # @note Throws `:propagated_result` when status is `error`.
                    #
                    def to_service_aware_iteration_block_value
                      key_mode.create_service_aware_iteration_block_value(self)
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
