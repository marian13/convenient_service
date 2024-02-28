# frozen_string_literal: true

module ConvenientService
  module Support
    class NeverReachHere < ::ConvenientService::Exception
      ##
      # @param extra_message [String]
      # @return [void]
      #
      def initialize_with_kwargs(extra_message:)
        message = <<~TEXT
          The code that was supposed to be unreachable was executed.

          #{extra_message}
        TEXT

        initialize(message)
      end
    end
  end
end
