# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class Arguments < SubMatchers::Base
                module Commands
                  class GeneratePrintableArguments < Support::Command
                    include Support::Delegate

                    ##
                    # @!attribute [r] arguments
                    #   @return [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Arguments]
                    #
                    attr_reader :arguments

                    ##
                    # @return [Array]
                    #
                    delegate :args, to: :arguments

                    ##
                    # @return [Hash]
                    #
                    delegate :kwargs, to: :arguments

                    ##
                    # @return [Proc]
                    #
                    delegate :block, to: :arguments

                    ##
                    # @param arguments [ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Arguments]
                    #
                    def initialize(arguments:)
                      @arguments = arguments
                    end

                    ##
                    # @return [String]
                    #
                    def call
                      return "" if arguments.null_arguments?

                      text =
                        if args.any? && kwargs.any?
                          "(#{printable_args}, #{printable_kwargs})"
                        elsif args.any?
                          "(#{printable_args})"
                        elsif kwargs.any?
                          "(#{printable_kwargs})"
                        else
                          "()"
                        end

                      text += " #{printable_block}" if block

                      text
                    end

                    ##
                    # @return [String]
                    #
                    def printable_args
                      args.map(&:inspect).join(", ")
                    end

                    ##
                    # @return [String]
                    #
                    def printable_kwargs
                      kwargs.map { |key, value| "#{key}: #{value.inspect}" }.join(", ")
                    end

                    ##
                    # @return [String]
                    #
                    def printable_block
                      block ? Utils::Proc.display(block) : ""
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
