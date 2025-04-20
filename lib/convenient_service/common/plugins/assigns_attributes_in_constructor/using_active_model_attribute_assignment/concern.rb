# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module AssignsAttributesInConstructor
        module UsingActiveModelAttributeAssignment
          module Concern
            include Support::Concern

            included do |service_class|
              service_class.include ::ActiveModel::AttributeAssignment
            end
          end
        end
      end
    end
  end
end
