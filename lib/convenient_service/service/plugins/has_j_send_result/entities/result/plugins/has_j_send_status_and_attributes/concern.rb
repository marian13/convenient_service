# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concern/class_methods"
require_relative "concern/instance_methods"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Concern
                  include Support::Concern

                  included do |result_class|
                    result_class.include InstanceMethods

                    result_class.extend ClassMethods
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
