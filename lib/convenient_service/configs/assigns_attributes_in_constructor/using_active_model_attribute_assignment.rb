# frozen_string_literal: true

module ConvenientService
  module Configs
    module AssignsAttributesInConstructor
      module UsingActiveModelAttributeAssignment
        include Support::Concern

        included do
          include Core

          concerns do
            use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern
          end

          middlewares for: :initialize do
            use Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware
          end
        end
      end
    end
  end
end
