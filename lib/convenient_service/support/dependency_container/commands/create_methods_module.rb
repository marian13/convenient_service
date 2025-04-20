# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class CreateMethodsModule < Support::Command
          ##
          # @return [Module]
          #
          def call
            ::Module.new do
              class << self
                ##
                # @return namespaces [ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection]
                #
                def namespaces
                  @namespaces ||= Entities::NamespaceCollection.new
                end
              end
            end
          end
        end
      end
    end
  end
end
