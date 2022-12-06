# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Commands
            class GeneratePrintableMethod < Support::Command
              include Support::Delegate

              ##
              # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
              #
              attr_reader :matcher

              ##
              # @return [Object]
              #
              delegate :object, to: :matcher

              ##
              # @return [Symbol, String]
              #
              delegate :method, to: :matcher

              ##
              # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher]
              # @return [void]
              #
              def initialize(matcher:)
                @matcher = matcher
              end

              def call
                case Utils::Object.resolve_type(object)
                when "class", "module"
                  "#{object}.#{method}"
                when "instance"
                  "#{object.class}##{method}"
                end
              end
            end
          end
        end
      end
    end
  end
end
