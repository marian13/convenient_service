# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                class Delegation
                  ##
                  # @!attribute [r] object
                  #   @return [Object] Can be any type.
                  #
                  attr_reader :object

                  ##
                  # @!attribute [r] method
                  #   @return [Symbol]
                  #
                  attr_reader :method

                  ##
                  # @!attribute [r] arguments
                  #   @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Delegation]
                  #
                  attr_reader :arguments

                  ##
                  # @param object [Object] Can be any type.
                  # @param method [Symbol]
                  # @param args [Array]
                  # @param kwargs [Hash]
                  # @param block [Proc]
                  # @return [void]
                  #
                  def initialize(object:, method:, args:, kwargs:, block:)
                    @object = object
                    @method = method
                    @arguments = Support::Arguments.new(*args, **kwargs, &block)
                  end

                  ##
                  # @return [Booleam]
                  #
                  def with_arguments?
                    arguments.any?
                  end

                  ##
                  # @return [Boolean]
                  #
                  def without_arguments?
                    !with_arguments?
                  end

                  ##
                  # @param other [Object]
                  # @return [Boolean]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if object != other.object
                    return false if method != other.method
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
  end
end
