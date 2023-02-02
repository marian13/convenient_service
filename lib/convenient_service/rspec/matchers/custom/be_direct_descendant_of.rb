# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
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
        class BeDirectDescendantOf
          def initialize(base_klass)
            @base_klass = base_klass
          end

          def matches?(klass)
            @klass = klass

            klass.superclass == base_klass
          end

          def description
            "be a direct descendant of `#{base_klass}`"
          end

          ##
          # NOTE: `failure_message` is only called when `matches?` returns `false`.
          # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers/MatcherProtocol#failure_message-instance_method
          #
          def failure_message
            "expected #{klass} to be a direct descendant of `#{base_klass}`"
          end

          ##
          # NOTE: `failure_message_when_negated` is only called when `matches?` returns `false`.
          # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers/MatcherProtocol#failure_message-instance_method
          #
          def failure_message_when_negated
            "expected #{klass} NOT to be a direct descendant of `#{base_klass}`"
          end

          private

          attr_reader :klass, :base_klass
        end
      end
    end
  end
end
