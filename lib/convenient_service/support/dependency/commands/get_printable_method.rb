# frozen_string_literal: true

module ConvenientService
  module Support
    module Dependency
      module Commands
        class GetPrintableMethod < Support::Command
          attr_reader :method, :object

          def initialize(method:, object:)
            @method = method
            @object = object
          end

          def call
            "#{type.capitalize} `#{method}'"
          end

          private

          ##
          # NOTE: Always returns `class' or `instance' since object is taken from `missing_method'.
          #
          def type
            @type ||= Utils::Object.resolve_type(object)
          end
        end
      end
    end
  end
end
