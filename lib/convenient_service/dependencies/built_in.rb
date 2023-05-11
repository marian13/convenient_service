# frozen_string_literal: true

##
# This file loads built-in dependencies (from Ruby standard library).
#
# @internal
#   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
##

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/forwardable/rdoc/Forwardable.html
#   - https://github.com/ruby/forwardable
#
require "forwardable"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
#   - https://github.com/ruby/logger
#
require "logger"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html
#   - https://github.com/ruby/observer
#
require "observer"

##
# @internal
#   - https://ruby-doc.org/stdlib-2.7.0/libdoc/ostruct/rdoc/OpenStruct.html
#   - https://github.com/ruby/ostruct
#
#   TODO: Move `ostruct` to test dependencies.
#
require "ostruct"

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
