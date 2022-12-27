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
                    class Base
                      ##
                      # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                      #
                      attr_reader :matcher

                      ##
                      # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
                      # @return [void]
                      #
                      def initialize(matcher:)
                        @matcher = matcher
                      end

                      ##
                      # @return [Boolean]
                      #
                      def allows?
                        false
                      end

                      ##
                      # @return [Boolean]
                      #
                      def does_not_allow?
                        return true unless allows?

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
