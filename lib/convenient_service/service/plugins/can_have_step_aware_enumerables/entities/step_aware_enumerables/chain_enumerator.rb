# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class ChainEnumerator < Entities::StepAwareEnumerables::Enumerator
              ##
              # @api private
              #
              # @return [Enumerator::Chain]
              #
              alias_method :chain_enumerator, :object
            end
          end
        end
      end
    end
  end
end
