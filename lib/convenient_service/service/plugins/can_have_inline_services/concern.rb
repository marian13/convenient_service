# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveInlineServices
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @api public
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveInlineServices::Entities::Proxy]
            #
            def inline(&block)
              Entities::Proxy.new(&block)
            end
          end
        end
      end
    end
  end
end
