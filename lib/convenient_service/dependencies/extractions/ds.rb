# frozen_string_literal: true

##
# @api private
#
# Defines `ds` helper in order to have a quick way to find differences between strings like `git diff`.
#
# @param first_string [String]
# @param second_string [String]
# @return [nil]
#
# @note `ds' is a dev-only helper.
# @note `ds` is a short for `diff_strings`.
#
# @example
#   first_string = <<~TEXT
#     Step of `AnonymousClass(#14360)` is passed as constructor argument `kwargs[:baz]` to `AnonymousClass(#14360)`.
#
#     It is an antipattern. It neglects the idea of steps.
#
#     Please, try to reorganize `AnonymousClass(#14400)` service.
#   TEXT
#
#   second_string = <<~TEXT
#     Step of `AnonymousClass(#14360)` is passed as constructor argument `kwargs[:baz]` to `AnonymousClass(#14400)`.
#
#     It is an antipattern. It neglects the idea of steps.
#
#     Please, try to reorganize `AnonymousClass(#14400)` service.
#   TEXT
#
#   ds(first_string, second_string)
#   =>
#   -Step of `AnonymousClass(#14360)` is passed as constructor argument `kwargs[:baz]` to `AnonymousClass(#14360)`.
#   +Step of `AnonymousClass(#14360)` is passed as constructor argument `kwargs[:baz]` to `AnonymousClass(#14400)`.
#
#   It is an antipattern. It neglects the idea of steps.
#
#   Please, try to reorganize `AnonymousClass(#14400)` service.
#
def ds(first_string, second_string)
  require "diffy"

  puts ::Diffy::Diff.new(first_string, second_string).to_s(:color)
end
