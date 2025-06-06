# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
#   result = ConvenientService::Examples::Standard::Factorial::Services::Calculate.result(number: 10)
#
module ConvenientService
  module Examples
    module Standard
      class Factorial
        module Services
          class Calculate
            include ConvenientService::Standard::Config

            attr_reader :number, :timeout_seconds

            def initialize(number:, timeout_seconds: 10)
              @number = number
              @timeout_seconds = timeout_seconds
            end

            def result
              return error("is `nil`") if number.nil?
              return error("is NOT an integer") unless number.instance_of?(::Integer)
              return error("is lower than `0`") if number < 0

              return error("Timeout (`#{timeout_seconds}` seconds) is exceeded for `#{number}`") if factorial.timeout?

              success(factorial: factorial.value)
            end

            private

            def factorial
              @factorial ||= Utils::Timeout.with_timeout(timeout_seconds) { calculate_factorial }
            end

            ##
            # @internal
            #   NOTE: What is a Factorial?
            #   - https://en.wikipedia.org/wiki/Factorial
            #
            #   NOTE: Minimal example: `require "timeout"; ::Timeout.timeout(10) { 1.upto(300_000).reduce(1) { |prev_value, next_value| prev_value * next_value } }`.
            #
            def calculate_factorial
              return 1 if [0, 1].include?(number)

              1.upto(number).reduce(1) { |prev_value, next_value| prev_value * next_value }
            end
          end
        end
      end
    end
  end
end
