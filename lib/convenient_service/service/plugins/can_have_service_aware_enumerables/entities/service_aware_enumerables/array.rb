# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveServiceAwareEnumerables
        module Entities
          module ServiceAwareEnumerables
            class Array < Entities::ServiceAwareEnumerables::Enumerable
              ##
              # @api private
              #
              # @return [Array]
              #
              alias_method :array, :object

              ##
              # @api private
              #
              # @return [Symbol]
              #
              def default_data_key
                :values
              end

              ##
              # @api private
              #
              # @return [Symbol]
              #
              def default_evaluate_by
                :to_a
              end
            end
          end
        end
      end
    end
  end
end
