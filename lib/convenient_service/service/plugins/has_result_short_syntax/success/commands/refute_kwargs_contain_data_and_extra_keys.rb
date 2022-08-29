# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Success
          module Commands
            class RefuteKwargsContainDataAndExtraKeys < Support::Command
              attr_reader :kwargs

              def initialize(kwargs:)
                @kwargs = kwargs
              end

              def call
                return unless kwargs.has_key?(:data)

                return if kwargs.keys.one?

                raise Errors::KwargsContainDataAndExtraKeys.new
              end
            end
          end
        end
      end
    end
  end
end
