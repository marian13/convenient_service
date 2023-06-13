# frozen_string_literal: true

module ConvenientService
  module Services
    class RunMethodInOrganizer
      ##
      # @internal
      #   TODO: Reuse parent config?
      #
      include Configs::Standard

      ##
      # @!attribute [r] method_name
      #   @return [Symbol]
      #
      attr_reader :method_name

      ##
      # @!attribute [r] organizer
      #   @return [Service]
      #
      attr_reader :organizer

      ##
      # @!attribute [r] kwargs
      #   @return [Hash{Symbol => Object}]
      #
      attr_reader :kwargs

      ##
      # @param method_name [Symbol]
      # @param organizer [Service]
      # @param kwargs [Hash{Symbol => Object}]
      # @return [void]
      #
      def initialize(method_name:, organizer:, **kwargs)
        @method_name = method_name
        @organizer = organizer
        @kwargs = kwargs
      end

      ##
      # @return [Result]
      #
      # @internal
      #   NOTE: `kwargs` are intentionally NOT passed to `organizer.__send__(method_name)`, since all the corresponding methods are available inside `organizer.__send__(method_name)` body.
      #
      def result
        organizer.__send__(method_name)
      end

      ##
      # @return [Hash{Symbol => Object}]
      #
      def inspect_values
        {name: "#{organizer.class.name}::RunMethod(:#{method_name})"}
      end
    end
  end
end
