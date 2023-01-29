# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          module Entities
            module Chainings
              module SubMatchers
                class AndReturn
                  attr_reader :expected_value

                  def initialize(expected_value)
                    @expected_value = expected_value
                  end

                  def matches?(object)
                    true
                  end

                  def description
                    "return value"
                  end

                  def failure_message
                    "I am failure message"
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
