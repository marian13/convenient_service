# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Services
            class FilterOutUnpermittedParams
              include ConvenientService::Standard::V1::Config

              attr_reader :params, :permitted_keys

              def initialize(params:, permitted_keys:)
                @params = params
                @permitted_keys = permitted_keys
              end

              def result
                success(params: params.slice(*permitted_keys))
              end
            end
          end
        end
      end
    end
  end
end
