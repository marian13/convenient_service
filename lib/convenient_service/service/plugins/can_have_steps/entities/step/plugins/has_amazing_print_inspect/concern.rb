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
              module HasAmazingPrintInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    # @internal
                    #   NOTE: `ai` is a part of public interface of `amazing_print`.
                    #   - https://github.com/amazing-print/amazing_print?tab=readme-ov-file#usage
                    #   - https://github.com/amazing-print/amazing_print/blob/master/lib/amazing_print/core_ext/kernel.rb
                    #
                    def inspect
                      metadata = {
                        ConvenientService: {
                          entity: "Step",
                          container: Utils::Class.display_name(container.klass)
                        }
                      }

                      metadata[:ConvenientService][:method] = ":#{method}" if method_step?
                      metadata[:ConvenientService][:service] = Utils::Class.display_name(service_class) if service_step?

                      metadata.ai
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
