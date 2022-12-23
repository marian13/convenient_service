# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            ##
            # @internal
            #   TODO: Generic `Support::Arguments` class.
            #
            class Arguments
              ##
              # @!attribute [r] args
              #   @return [Array]
              #
              attr_reader :args

              ##
              # @!attribute [r] kwargs
              #   @return [Hash]
              #
              attr_reader :kwargs

              ##
              # @!attribute [r] block
              #   @return [Proc]
              #
              attr_reader :block

              ##
              # @param args [Array]
              # @param kwargs [Hash]
              # @param block [Proc]
              # @return [void]
              #
              def initialize(args: [], kwargs: {}, block: nil)
                @args = args
                @kwargs = kwargs
                @block = block
              end

              ##
              # @param other [Object]
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if args != other.args
                return false if kwargs != other.kwargs
                return false if block != other.block

                true
              end
            end
          end
        end
      end
    end
  end
end
