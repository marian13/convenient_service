# frozen_string_literal: true

module ConvenientService
  module Errors
    class ConcernMiddlewareStackIsCommitted < ConvenientService::Error
      def initialize(stack:)
        message = <<~TEXT
          Concern middleware stack is already committed.

          Did you call `concerns(&block)` after using any plugin, after calling `commit_config!`?
        TEXT

        super(message)
      end
    end
  end
end
