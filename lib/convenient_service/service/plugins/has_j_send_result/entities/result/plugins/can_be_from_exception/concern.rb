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
              module CanBeFromException
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api public
                    #
                    # @return [Boolean]
                    #
                    def from_unhandled_exception?
                      Utils.to_bool(unhandled_exception)
                    end

                    ##
                    # @api public
                    #
                    # @return [StandardError, nil]
                    #
                    def unhandled_exception
                      extra_kwargs[:unhandled_exception]
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
