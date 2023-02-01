# frozen_string_literal: true

module ConvenientService
  module Services
    class RunOwnMethodInOrganizer
      module Errors
        class MethodForStepIsNotDefined < ConvenientService::Error
          def initialize(service_class:, method_name:)
            message = <<~TEXT
              Service #{service_class} tries to use `#{method_name}` method in a step, but it NOT defined.

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

      attr_reader :method_name, :organizer, :kwargs

      def initialize(method_name:, organizer:, **kwargs)
        @method_name = method_name
        @organizer = organizer
        @kwargs = kwargs
      end

      def result
        raise Errors::MethodForStepIsNotDefined.new(service_class: organizer.class, method_name: method_name) unless own_method

        ##
        # NOTE: `kwargs` are intentionally NOT passed, since all the corresponding methods are available inside `own_method` body.
        #
        own_method.call
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
