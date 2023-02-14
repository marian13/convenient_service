# frozen_string_literal: true

require "convenient_service/support/dependency_container/constants"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          module Container
            include ConvenientService::DependencyContainer::Export

            export :"DependencyContainer::Constants", scope: :class do
              ConvenientService::Support::DependencyContainer::Constants
            end
          end
        end
      end
    end
  end
end
