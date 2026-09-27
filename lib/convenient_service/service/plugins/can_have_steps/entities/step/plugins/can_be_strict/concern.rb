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
              module CanBeStrict
                module Concern
                  include ::ConvenientService::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def strict?
                      params.extra_kwargs[:strict] == true
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
