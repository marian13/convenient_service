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
                    class WithCallingOriginal < Chainings::Permissions::Base
                      ##
                      # @return [Boolean]
                      #
                      def allows?
                        true
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
