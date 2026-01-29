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
            class Object < Entities::ServiceAwareEnumerables::Base
              ##
              # @return [Symbol]
              #
              def default_data_key
                :value
              end

              ##
              # @return [nil]
              #
              def default_evaluate_by
                nil
              end

              private

              ##
              # @param method_name [Symbol, String]
              # @param include_private [Boolean]
              # @return [Boolean]
              #
              def respond_to_missing?(method_name, include_private = false)
                respond_to?(method_name, include_private)
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Exceptions::AlreadyUsedTerminalChaining]
              #
              def method_missing(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end
            end
          end
        end
      end
    end
  end
end
