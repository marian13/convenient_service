# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Errors
              class InvalidStep < ConvenientService::Error
                def initialize(step:)
                  message = <<~TEXT
                    Step `#{step}` is NEITHER a Class NOR a Symbol.
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
