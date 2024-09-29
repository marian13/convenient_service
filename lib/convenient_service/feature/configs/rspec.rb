# frozen_string_literal: true

module ConvenientService
  module Feature
    module Configs
      module RSpec
        include ConvenientService::Config

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          if Dependencies.rspec.loaded?
            include Configs::Essential

            concerns do
              use ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Concern
            end

            middlewares :entry do
              unshift ConvenientService::Plugins::Feature::CanHaveStubbedEntries::Middleware
            end
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end
