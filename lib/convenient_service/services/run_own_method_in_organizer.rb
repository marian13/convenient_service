# frozen_string_literal: true

module ConvenientService
  module Services
    class RunOwnMethodInOrganizer
      module Errors
        class MethodForStepIsNotDefined < ::ConvenientService::Error
          ##
          # @param service_class [Class]
          # @param method_name [Symbol]
          # @return [void]
          #
          def initialize(service_class:, method_name:)
            message = <<~TEXT
              Service `#{service_class}` tries to use `#{method_name}` method in a step, but it is NOT defined.

              Did you forget to define it?
            TEXT

            super(message)
          end
        end
      end

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
      #   NOTE: `kwargs` are intentionally NOT passed to `own_method.call`, since all the corresponding methods are available inside `own_method` body.
      #
      def result
        raise Errors::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name) unless own_method

        own_method.call
      end

      ##
      # @return [Hash{Symbol => Object}]
      #
      def inspect_values
        {name: "#{organizer.class.name}::RunMethod(:#{method_name})"}
      end

      private

      ##
      # @return [Method, nil]
      #
      # @internal
      #   TODO: A possible bottleneck. Should be removed if receives negative feedback.
      #
      #   NOTE: `own_method.bind(organizer).call` is logically the same as `own_method.bind_call(organizer)`.
      #   - https://ruby-doc.org/core-2.7.1/UnboundMethod.html#method-i-bind_call
      #   - https://blog.saeloun.com/2019/10/17/ruby-2-7-adds-unboundmethod-bind_call-method.html
      #
      def own_method
        method = Utils::Module.get_own_instance_method(organizer.class, method_name, private: true)

        return unless method

        method.bind(organizer)
      end
    end
  end
end
