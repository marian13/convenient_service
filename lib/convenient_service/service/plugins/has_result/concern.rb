# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasResult::Exceptions::ResultIsNotOverridden]
            #
            def result(...)
              new(...).result
            end
          end

          instance_methods do
            ##
            # @api public
            # @raise [ConvenientService::Service::Plugins::HasResult::Exceptions::ResultIsNotOverridden]
            #
            def result
              ::ConvenientService.raise Exceptions::ResultIsNotOverridden.new(service: self)
            end
          end
        end
      end
    end
  end
end
