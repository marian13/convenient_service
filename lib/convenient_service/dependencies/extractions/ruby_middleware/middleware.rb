# frozen_string_literal: true

##
# @internal
#   NOTE:
#     Copied from `Ibsciss/ruby-middleware` without any logic modification.
#     Version: v0.4.2.
#     - Wrapped in a namespace `ConvenientService::Dependencies::Extractions::RubyMiddleware`.
#     - Replaced `require` into `require_relative`.
#     - Added support of middleware creators.
#
#   - https://github.com/marian13/ruby-middleware/blob/v0.4.2/lib/middleware.rb
#
require_relative "middleware/builder"
require_relative "middleware/runner"
