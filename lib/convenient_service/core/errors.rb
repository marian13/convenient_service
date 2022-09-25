# frozen_string_literal: true

module ConvenientService
  module Errors
    class ConcernMiddlewareStackIsFixed < ConvenientService::Error
      def initialize(stack:)
        message = <<~TEXT
          Concern middleware stack is already committed.

          Did you call `concerns(&block)' after using any plugin?
        TEXT

        super(message)
      end
    end
  end
end
