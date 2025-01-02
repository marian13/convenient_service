# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasMemoization
        module UsingMemoWise
          module Concern
            include Support::Concern

            included do
              prepend ::MemoWise
            end
          end
        end
      end
    end
  end
end
