# frozen_string_literal: true

module ConvenientService
  module Support
    module PatternMatching
      module Entities
        ##
        # TODO: Specs.
        #
        class Pattern
          attr_reader :hash

          def initialize(hash)
            @hash = hash
          end

          def match_first(*values)
            ##
            # TODO: Explain why `hash[values]' won't work.
            # TODO: Explain why `hash.find { |key| key == values }'.
            #
            _key, matched = hash.find { |key, _matched| key == values }

            matched
          end
        end
      end
    end
  end
end
