# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module RaisesOnNotCheckedResultStatus
                module Errors
                  class StatusIsNotChecked < ConvenientService::Error
                    def initialize(attribute:)
                      message = <<~TEXT
                        Attribute `#{attribute}' is accessed before result status is checked.

                        Did you forget to call `success?', `failure?', or `error?' on result?
                      TEXT

                      super(message)
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
