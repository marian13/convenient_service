# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        ##
        # NOTE: Navigate to the link below and `Ctrl + F` for "Custom Matcher from scratch"
        # for a guide of how to define a complex custom matcher.
        # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers
        #
        # More info:
        # - https://relishapp.com/rspec/rspec-expectations/v/3-11/docs/custom-matchers/define-a-custom-matcher
        # - http://rspec.info/documentation/3.9/rspec-expectations/RSpec/Matchers/MatcherProtocol.html
        # - https://makandracards.com/makandra/662-write-custom-rspec-matchers
        #
        class BeDescendantOf
          def initialize(base_klass)
            @base_klass = base_klass
          end

          def matches?(klass)
            @klass = klass

            Utils.to_bool(klass < base_klass)
          end

          def description
            "be a descendant of `#{base_klass}`"
          end

          ##
          # NOTE: `failure_message` is only called when `matches?` returns `false`.
          # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers/MatcherProtocol#failure_message-instance_method
          #
          def failure_message
            "expected #{klass} to be a descendant of `#{base_klass}`"
          end

          ##
          # NOTE: `failure_message_when_negated` is only called when `matches?` returns `false`.
          # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers/MatcherProtocol#failure_message-instance_method
          #
          def failure_message_when_negated
            "expected #{klass} NOT to be a descendant of `#{base_klass}`"
          end

          private

          attr_reader :klass, :base_klass
        end
      end
    end
  end
end
