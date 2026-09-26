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
                  include ::ConvenientService::Concern

                  instance_methods do
                    ##
                    # @api public
                    #
                    # @return [Boolean]
                    #
                    def from_exception?
                      Utils.to_bool(exception)
                    end

                    ##
                    # @api public
                    #
                    # @return [StandardError, nil]
                    #
                    def exception
                      extra_kwargs[:exceptions]&.values&.first
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
