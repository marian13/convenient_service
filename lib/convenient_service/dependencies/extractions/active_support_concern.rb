# frozen_string_literal: true

##
# @internal
#   NOTE:
#     Copied from `rails/rails` with some logic modification.
#     Version: v7.0.3.1.
#     Wrapped in a namespace `ConvenientService::Dependencies::Extractions::ActiveSupportConcern`.
#     Added `instance_methods` that works in a similar way as `class_methods`.
#     Also `ClassMethods` (and `InstanceMethods`) are loaded after `included` block, not as in the original implementation.
#
#   - https://github.com/marian13/rails/blob/v7.0.3.1/activesupport/lib/active_support/concern.rb
#   - https://github.com/rails/rails/blob/v7.0.3.1/activesupport/lib/active_support/concern.rb
#   - https://github.com/rails/rails
#
require_relative "active_support_concern/concern"
