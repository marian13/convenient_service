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
                    class Base
                      ##
                      # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
                      #
                      attr_reader :matcher

                      ##
                      # @return [Object] Can be any type.
                      #
                      attr_reader :value

                      ##
                      # @param matcher [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
                      # @return [void]
                      #
                      def initialize(matcher:)
                        @matcher = matcher
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
