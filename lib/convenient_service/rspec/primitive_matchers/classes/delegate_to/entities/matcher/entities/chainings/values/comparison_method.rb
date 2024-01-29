# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module Values
                    class ComparisonMethod < Chainings::Values::Base
                      ##
                      # @return [Boolean]
                      #
                      def value
                        matcher.comparison_method
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
