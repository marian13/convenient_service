# frozen_string_literal: true

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

            export :"DependencyContainer::Errors" do
              ConvenientService::Support::DependencyContainer::Errors
            end
          end
        end
      end
    end
  end
end
