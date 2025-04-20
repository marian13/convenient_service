# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Concern
          include Support::Concern

          included do |service_class|
            service_class.include InstanceMethods

            service_class.extend ClassMethods
          end
        end
      end
    end
  end
end
