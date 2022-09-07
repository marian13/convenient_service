# frozen_string_literal: true

module ConvenientService
  module Configs
    module AssignsAttributesInConstructor
      module UsingDryInitializer
        include Support::Concern

        included do
          include Core

          concerns do
            use Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern
          end
        end
      end
    end
  end
end
