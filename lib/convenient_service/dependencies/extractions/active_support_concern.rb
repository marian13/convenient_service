# frozen_string_literal: true

##
# @internal
#   NOTE:
#     Copied from `rails/rails` with some logic modification.
#     Version: v7.0.4.3.
#     Wrapped in a namespace `ConvenientService::Dependencies::Extractions::ActiveSupportConcern`.
#     Added `instance_methods` that works in a similar way as `class_methods`.
#     Added `signleton_class_methods` that works in a similar way as `class_methods`.
#     Also `ClassMethods` (`InstanceMethods` and `SingletonClassMethods`) are loaded after `included` block, not as in the original implementation.
#
#   - https://github.com/rails/rails/blob/v7.0.4.3/activesupport/lib/active_support/concern.rb
#   - https://github.com/marian13/rails/blob/v7.0.4.3/activesupport/lib/active_support/concern.rb
#   - https://github.com/rails/rails
#
#   NOTE: It is ok that `MultipleIncludedBlocks` and `MultiplePrependBlocks` inherit from `StandardError` since dependencies are on the lower layer.
#
#   TODO: Move `Concern` to support? Rescue and reraise errors?
#   - https://github.com/marian13/convenient_service/wiki/Design:-Communication-Graph
#
require_relative "active_support_concern/concern"
