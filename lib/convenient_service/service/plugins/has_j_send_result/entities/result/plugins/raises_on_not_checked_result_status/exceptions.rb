# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module RaisesOnNotCheckedResultStatus
                module Exceptions
                  class StatusIsNotChecked < ::ConvenientService::Exception
                    def initialize_with_kwargs(attribute:)
                      message = <<~TEXT
                        Attribute `#{attribute}` is accessed before result status is checked.

                        Did you forget to call `success?`, `failure?`, or `error?` on result?
                      TEXT

                      initialize(message)
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
end
