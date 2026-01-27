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
                    # @param renamings [Hash{Symbol => Symbol}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_renamed_keys(renamings)
                      return self if status.unsafe_not_success?
                      return self unless renamings

                      data_with_renamings =
                        renamings.each_with_object(unsafe_data.to_h.dup) do |(key, renamed_key), data|
                          if data.has_key?(key)
                            data[renamed_key] = data.delete(key)
                          else
                            ::ConvenientService.raise Exceptions::NotExistingAttribute.new(key: key, renamed_key: renamed_key)
                          end
                        end

                      copy(overrides: {kwargs: {data: data_with_renamings}})
                    end

                    ##
                    # @api public
                    #
                    # @param values [Hash{Symbol => Object}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def with_extra_keys(values)
                      return self if status.unsafe_not_success?
                      return self unless values

                      copy(overrides: {kwargs: {data: unsafe_data.to_h.merge(values)}})
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
