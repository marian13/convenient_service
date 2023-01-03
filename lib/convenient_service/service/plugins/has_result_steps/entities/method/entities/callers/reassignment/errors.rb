# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Reassignment < Callers::Base
                  module Errors
                    class CallerCanNotCalculateReassignment < ::ConvenientService::Error
                      def initialize(method:)
                        message = <<~TEXT
                          Method caller failed to calculate reassignment for `#{method.name}`.

                          Method callers can calculate only `in` methods, while reassignments are always `out` methods.
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
end
