# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          module Container
            include ConvenientService::DependencyContainer::Export

            export :"DependencyContainer::Constants::DEFAULT_SCOPE" do
              ConvenientService::Support::DependencyContainer::Constants::DEFAULT_SCOPE
            end

            export :"DependencyContainer::Commands::AssertValidContainer" do
              ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer
            end

            export :"DependencyContainer::Commands::AssertValidScope" do
              ConvenientService::Support::DependencyContainer::Commands::AssertValidScope
            end
          end
        end
      end
    end
  end
end
