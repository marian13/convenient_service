# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module HasInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    def inspect
                      return "<#{Utils::Class.display_name(container.klass)}::Step method: :#{method}>" if method_step?
                      return "<#{Utils::Class.display_name(container.klass)}::Step service: #{Utils::Class.display_name(service_class)}>" if service_step?

                      "<#{Utils::Class.display_name(container.klass)}::Step>"
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
