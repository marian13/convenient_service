# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module Values
                    class WithoutCallingOriginal < Chainings::Values::Base
                      ##
                      # @return [Boolean]
                      #
                      def value
                        false
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
