# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        module UsingActiveModelValidations
          module Concern
            include Support::Concern

            included do |service_class|
              service_class.include ::ActiveModel::Validations
            end
          end
        end
      end
    end
  end
end
