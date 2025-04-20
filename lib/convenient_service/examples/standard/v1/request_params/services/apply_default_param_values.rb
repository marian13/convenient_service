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
            class ApplyDefaultParamValues
              include ConvenientService::Standard::V1::Config

              attr_reader :params, :defaults

              def initialize(params:, defaults:)
                @params = params
                @defaults = defaults
              end

              def result
                success(params: defaults.merge(params))
              end
            end
          end
        end
      end
    end
  end
end
