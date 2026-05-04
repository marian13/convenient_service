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

                    ##
                    # TODO: error.from_exception(exception)
                    # TODO: error.from_exception(exception, max_backtrace_size: 5)
                    # TODO: error("custom_message").from_exception(exception)
                    # TODO: error(code: :custom_code).from_exception(exception)
                    #
                    # @internal
                    #   If `error` message is default, use `from_exception` message.
                    #   If `error` code is default, use `from_exception` code.
                    #
                    # def from_exception(exception, **kwargs)
                    #   # ...
                    # end
                    ##
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
