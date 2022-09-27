# frozen_string_literal: true

require_relative "concerns/entities"
require_relative "concerns/errors"

module ConvenientService
  module Core
    module Entities
      class Concerns
        ##
        #
        #
        def initialize(entity:)
          @stack = Entities::Stack.new(entity: entity)

          initialize_include_state!
        end

        ##
        #
        #
        def assert_not_included!
          return unless included?

          raise Errors::ConcernsAreIncluded.new(concerns: concerns)
        end

        ##
        #
        #
        def configure(&configuration_block)
          stack.instance_exec(&configuration_block)
        end

        ##
        # Includes concerns into entity when called for the first time.
        # Does nothing for the subsequent calls.
        #
        # @return [Boolen] true if called for the first time, false otherwise.
        #
        def include!
          stack.call(entity: stack.entity) unless included?

          transit_to_next_include_state!

          just_included?
        end

        ##
        # Checks whether concerns are already included into entity (include! was called multiple times).
        #
        # @return [Boolean]
        #
        def already_included?
          include_state == :already_included
        end

        ##
        # Checks whether concerns are just included into entity (include! was called only once).
        #
        # @return [Boolean]
        #
        def just_included?
          include_state == :just_included
        end

        ##
        # Checks whether concerns are included into entity (include! was called at least once).
        #
        # @return [Boolean]
        #
        def included?
          already_included? || just_included?
        end

        ##
        # @return [Array<Module>] concerns as plain modules.
        #
        def to_a
          stack.to_a.map(&:first).map(&:concern)
        end

        private

        attr_reader :stack, :include_state

        def initialize_include_state!
          @include_state = :not_included
        end

        def transit_to_next_include_state!
          current_state = @include_state

          next_state =
            case current_state
            when :not_included then :just_included
            when :just_included then :already_included
            when :already_included then :already_included
            end

          @include_state = next_state
        end
      end
    end
  end
end
