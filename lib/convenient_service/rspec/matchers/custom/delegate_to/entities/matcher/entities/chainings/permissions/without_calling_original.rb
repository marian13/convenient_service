# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                module Chainings
                  module Permissions
                    class WithoutCallingOriginal < Chainings::Permissions::Base
                      ##
                      # @return [Boolean]
                      #
                      def allows?
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
