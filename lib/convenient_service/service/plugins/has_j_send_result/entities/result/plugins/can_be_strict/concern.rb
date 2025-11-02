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
              module CanBeStrict
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api public
                    #
                    # @return [Boolean]
                    #
                    def strict?
                      Utils.to_bool(extra_kwargs[:strict_result])
                    end

                    ##
                    # When the result has the `success` status, it returns self.
                    # When the result has the `failure` status, it returns copy with `error` status.
                    # When the result has the `error` status, it returns self.
                    #
                    # @api public
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    def strict
                      return self unless status.unsafe_failure?

                      copy(
                        overrides: {
                          kwargs: {
                            status: :error,
                            strict_result: true
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
