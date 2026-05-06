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
              module CanBeFromHandledException
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api public
                    #
                    # @return [Boolean]
                    #
                    def from_handled_exception?
                      Utils.to_bool(handled_exception)
                    end

                    ##
                    # @api public
                    #
                    # @return [StandardError, nil]
                    #
                    def handled_exception
                      extra_kwargs.dig(:exceptions, :handled)
                    end

                    def from_exception(exception, **kwargs)
                      ::ConvenientService.raise Exceptions::FromExceptionOnNotErrorResult.new(result: self) unless status.unsafe_error?
                      data =
                        if Service::Plugins::HasJSendResult.default_error_data == unsafe_data.to_h
                          {handled_exception: exception}
                        else
                          unsafe_data
                        end

                      message =
                        if Service::Plugins::HasJSendResult.default_error_message == unsafe_message.to_s
                          Service::Plugins::CanHaveFormattedExceptions.format_exception(exception, **kwargs)
                        else
                          unsafe_message
                        end

                      code =
                        if Service::Plugins::HasJSendResult.default_error_code == unsafe_code.to_sym
                          :handled_exception
                        else
                          unsafe_code
                        end

                      copy(
                        overrides: {
                          kwargs: {
                            data: data,
                            message: message,
                            code: code,
                            exceptions: {handled: exception}
                          }
                        }
                      )
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
