# frozen_string_literal: true

module ConvenientService
  module Configs
    module HasAttributes
      module UsingActiveModelAttributes
        include Support::Concern

        included do
          include Core

          concerns do
            use Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern
          end
        end
      end
    end
  end
end
