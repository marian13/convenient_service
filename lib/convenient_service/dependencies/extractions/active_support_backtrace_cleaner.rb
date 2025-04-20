# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @internal
#   NOTE:
#     Copied from `rails/rails` without any logic modification.
#     Version: v7.1.2.
#     Wrapped in a namespace `ConvenientService::Dependencies::Extractions::ActiveSupportBacktraceCleaner`.
#
#   - https://api.rubyonrails.org/v7.1.2/classes/ActiveSupport/BacktraceCleaner.html
#   - https://github.com/rails/rails/blob/v7.1.2/activesupport/lib/active_support/backtrace_cleaner.rb
#   - https://github.com/marian13/rails/blob/main/activesupport/lib/active_support/backtrace_cleaner.rb
#   - https://github.com/rails/rails
#
require_relative "active_support_backtrace_cleaner/backtrace_cleaner"
