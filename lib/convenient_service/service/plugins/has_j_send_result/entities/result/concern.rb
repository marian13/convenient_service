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
            ##
            # @api private
            # @since 1.0.0
            #
            module Concern
              include Support::Concern

              instance_methods do
                ##
                # Returns string representation of result.
                #
                # @api public
                # @since 1.0.0
                #
                # @param format [Symbol]
                # @return [String]
                #
                # @note Intended to be used for debugging purposes.
                #
                # @example Common usage.
                #   class Service
                #     include ConvenientService::Standard::Config
                #
                #     def result
                #       success
                #     end
                #   end
                #
                #   puts Service.result
                #   # <Service::Result status: :success>
                #   # => nil
                #
                #   Service.result.to_s
                #   # => "<Service::Result status: :success>"
                #
                #   Service.result.to_s(format: :inspect)
                #   # => "<Service::Result status: :success>"
                #
                #   Service.result.to_s(format: :original)
                #   # => "#<Service::Result:0x00005639cd363000>"
                #
                def to_s(format: :inspect)
                  (format == :inspect) ? inspect : super()
                end
              end
            end
          end
        end
      end
    end
  end
end
