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
              module CanBeUsedInServiceAwareEnumerables
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api private
                    #
                    def to_service_aware_iteration_block_value
                      if result.success?
                        if outputs.none?
                          return true
                        elsif outputs.one?
                          return result.unsafe_data[outputs.first.key.to_sym]
                        else
                          return outputs.each_with_object({}) { |output, hash| hash[output.key.to_sym] = result.unsafe_data[output.key.to_sym] }
                        end
                      end

                      if result.failure?
                        return outputs.none? ? false : nil
                      end

                      throw :propagated_result, {propagated_result: result}
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
