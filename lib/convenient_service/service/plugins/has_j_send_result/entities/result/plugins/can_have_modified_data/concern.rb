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
              module CanHaveModifiedData
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api public
                    #
                    # @param keys [Array<Symbol>]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_only_keys(*keys)
                      return self if status.unsafe_not_success?
                      return self if keys.empty?

                      data_with_only_keys =
                        keys.each_with_object({}) do |key, data_with_only_keys|
                          if unsafe_data.__has_attribute__?(key)
                            data_with_only_keys[key] = unsafe_data[key]
                          else
                            ::ConvenientService.raise Exceptions::NotExistingAttributeForOnly.new(key: key)
                          end
                        end

                      copy(overrides: {kwargs: {data: data_with_only_keys}})
                    end

                    ##
                    # @api public
                    #
                    # @param keys [Array<Symbol>]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_except_keys(*keys)
                      return self if status.unsafe_not_success?
                      return self if keys.empty?

                      data_with_except_keys =
                        keys.each_with_object(unsafe_data.to_h.dup) do |key, data_with_except_keys|
                          if unsafe_data.__has_attribute__?(key)
                            data_with_except_keys.delete(key)
                          else
                            ::ConvenientService.raise Exceptions::NotExistingAttributeForExcept.new(key: key)
                          end
                        end

                      copy(overrides: {kwargs: {data: data_with_except_keys}})
                    end

                    ##
                    # @api public
                    #
                    # @param renamings [Hash{Symbol => Symbol}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_renamed_keys(**renamings)
                      return self if status.unsafe_not_success?
                      return self if renamings.empty?

                      data_with_renamed_keys =
                        renamings.each_with_object(unsafe_data.to_h.dup) do |(key, renamed_key), data_with_renamed_keys|
                          if unsafe_data.__has_attribute__?(key)
                            data_with_renamed_keys[renamed_key] = data_with_renamed_keys.delete(key)
                          else
                            ::ConvenientService.raise Exceptions::NotExistingAttributeForRename.new(key: key, renamed_key: renamed_key)
                          end
                        end

                      copy(overrides: {kwargs: {data: data_with_renamed_keys}})
                    end

                    ##
                    # @api public
                    #
                    # @param values [Hash{Symbol => Object}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_extra_keys(**values)
                      return self if status.unsafe_not_success?
                      return self if values.empty?

                      data_with_extra_keys = unsafe_data.to_h.merge(values)

                      copy(overrides: {kwargs: {data: data_with_extra_keys}})
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
