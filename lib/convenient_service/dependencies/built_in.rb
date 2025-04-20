# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# This file loads built-in dependencies (from Ruby standard library).
#
# @internal
#   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
##

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/pathname/rdoc/Pathname.html
#   - https://github.com/ruby/pathname
#
require "pathname"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/forwardable/rdoc/Forwardable.html
#   - https://github.com/ruby/forwardable
#
require "forwardable"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/erb/rdoc/ERB.html
#   - https://github.com/ruby/erb
#
require "erb"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
#   - https://github.com/ruby/logger
#
require "logger"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/rubygems/rdoc/Gem/Version.html
#   - https://github.com/rubygems/rubygems
#   - https://github.com/rubygems/rubygems/blob/master/lib/rubygems/version.rb
#
require "rubygems"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/singleton/rdoc/Singleton.html
#   - https://github.com/ruby/singleton
#
require "singleton"

##
# @internal
#   - https://ruby-doc.org/core-2.7.0/Mutex.html
#   - https://docs.ruby-lang.org/en/2.1.0/Mutex.html
#
require "thread"
