# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Concern
          module InstanceMethods
            ##
            # @api public
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def success(**kwargs)
              self.class.success(**kwargs.merge(service: self))
            end

            ##
            # @api public
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def failure(**kwargs)
              self.class.failure(**kwargs.merge(service: self))
            end

            ##
            # @api public
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def error(**kwargs)
              self.class.error(**kwargs.merge(service: self))
            end
          end
        end
      end
    end
  end
end
