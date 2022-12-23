# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Delegation
              ##
              # @!attribute [r] arguments
              #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Delegation]
              #
              attr_reader :arguments

              ##
              # @param args [Array]
              # @param kwargs [Hash]
              # @param block [Proc]
              # @return [void]
              #
              def initialize(args:, kwargs:, block:)
                @arguments = Entities::Arguments.new(args: args, kwargs: kwargs, block: block)
              end

              ##
              # @param other [Object]
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if arguments != other.arguments

                true
              end
            end
          end
        end
      end
    end
  end
end
