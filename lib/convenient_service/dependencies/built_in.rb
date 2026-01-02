# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# This file loads built-in dependencies (from Ruby standard library).
#
# @internal
#   - https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
#
#   NOTE: Ensure all `require` for built-in dependencies are explicit.
#   - https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Lint/RedundantRequireStatement
##

##
# NOTE: Dependencies must be kept in sync with `convenient_service.gemspec`.
##

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/rubygems/rdoc/Gem/Version.html
#   - https://github.com/rubygems/rubygems
#   - https://github.com/rubygems/rubygems/blob/master/lib/rubygems/version.rb
#
# @!visibility private
#
require "rubygems"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/forwardable/rdoc/Forwardable.html
#   - https://github.com/ruby/forwardable
#
# @!visibility private
#
require "forwardable"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
#   - https://github.com/ruby/logger
#
# @!visibility private
#
require "logger"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/pathname/rdoc/Pathname.html
#   - https://github.com/ruby/pathname
#
# @!visibility private
#
require "pathname"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/set/rdoc/Set.html
#   - https://github.com/ruby/set
#
# @!visibility private
#
require "set"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/singleton/rdoc/Singleton.html
#   - https://github.com/ruby/singleton
#
# @!visibility private
#
require "singleton"

##
# @internal
#   - https://ruby-doc.org/core-2.7.0/Mutex.html
#   - https://docs.ruby-lang.org/en/2.1.0/Mutex.html
#
# @!visibility private
#
# rubocop:disable Lint/RedundantRequireStatement
require "thread"
# rubocop:enable Lint/RedundantRequireStatement
