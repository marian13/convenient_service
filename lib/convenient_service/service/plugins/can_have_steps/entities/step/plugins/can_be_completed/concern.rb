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
              module CanBeCompleted
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def evaluated?
                      Utils.to_bool(internals.cache[:evaluated])
                    end

                    ##
                    # @return [Bool]
                    #
                    def not_evaluated?
                      !evaluated?
                    end

                    ##
                    # @return [void]
                    #
                    def mark_as_evaluated!
                      internals.cache[:evaluated] = true
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
