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
              module CanBeCalled
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # When the result has the `success` status, it returns the result data as a hash.
                    # When the result has the `failure` status, it returns `nil`.
                    # When the result has the `error` status, it raises an `ErrorResultIsCalled` exception.
                    #
                    # @api public
                    #
                    # @return [Hash{Symbol => Object}, nil]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled]
                    #
                    # @note `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanBeCalled::Exceptions::ErrorResultIsCalled` is aliased as `ConvenientService::Result::Exceptions::ErrorResultIsCalled`.
                    #
                    def call
                      case status.to_sym
                      when :success
                        unsafe_data.to_h
                      when :failure
                        nil
                      else # :error
                        ::ConvenientService.raise Exceptions::ErrorResultIsCalled.new(result: self)
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
