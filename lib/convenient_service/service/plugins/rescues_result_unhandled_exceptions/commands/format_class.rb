# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RescuesResultUnhandledExceptions
        module Commands
          class FormatClass < Support::Command
            ##
            # @!attribute [r] klass
            #   @return [Class]
            #
            attr_reader :klass

            ##
            # @param klass [Class]
            # @return [void]
            #
            def initialize(klass:)
              @klass = klass
            end

            ##
            # @return [String]
            #
            # @note Exceptions formatting is inspired by RSpec. It has almost the same output (at least for RSpec 3).
            #
            # @example Line.
            #
            #   StandardError:
            #
            def call
              "#{klass}:"
            end
          end
        end
      end
    end
  end
end
