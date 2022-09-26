# frozen_string_literal: true

module ConvenientService
  module Utils
    module Proc
      ##
      # TODO: Compose.
      #
      # TODO: Disjunct.
      #
      class Conjunct < Support::Command
        attr_reader :procs

        def initialize(procs)
          @procs = procs
        end

        ##
        # Creates a conjunction of procs.
        # All procs should accept only one argument.
        #
        # For example, let's assume we have two arbitrary functions:
        #   f(x) and g(x)
        #
        # Application of the `conjunct` procedure gives a new function h(x) that can be written as follows:
        #   h(x) = f(x) && g(x)
        #
        # IMPORTANT: Please, learn what is a conjunction before diving into implementation details.
        # - https://en.wikipedia.org/wiki/Logical_conjunction
        #
        def call
          return ->(item) { false } if procs.none?

          return procs.first if procs.one?

          ##
          # NOTE: reduce tries to use first element as its initial value if not specified explicitly.
          # https://ruby-doc.org/core-2.6/Enumerable.html#method-i-reduce
          #
          # NOTE: proc can be called by `[]`.
          # https://ruby-doc.org/core-2.7.1/Proc.html#method-i-5B-5D
          #
          procs.reduce(->(item) { true }) { |conjunction, proc| ->(item) { conjunction[item] && proc[item] } }
        end
      end
    end
  end
end
