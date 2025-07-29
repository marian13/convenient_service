# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @internal
#   NOTE: `rescue ::StandardError => exception` is the same as `rescue => exception`.
#
#   IMPORTANT: CRuby `Kernel.raise` supports `cause` keyword starting from 2.6.
#   JRuby 9.4 says that it is Ruby 3.1 compatible, but it still does NOT support `cause` keyword.
#   - https://ruby-doc.org/core-2.5.0/Kernel.html#method-i-raise
#   - https://ruby-doc.org/core-2.6/Kernel.html#method-i-raise
#   - https://github.com/jruby/jruby/blob/9.4.0.0/core/src/main/java/org/jruby/RubyKernel.java#L881
#   - https://github.com/ruby/spec/blob/master/core/kernel/raise_spec.rb#L5
#
return unless ConvenientService::Dependencies.ruby.match?("jruby < 10.1")

module ConvenientService
  class << self
    ##
    # @api public
    # @param original_exception [StandardError]
    # @raise [StandardError]
    #
    def raise(original_exception)
      ::Kernel.raise original_exception
    rescue => exception
      ::Kernel.raise exception.class, exception.message, backtrace_cleaner.clean(exception.backtrace)
    end

    ##
    # @api public
    # @return [Object] Can be any type.
    # @raise [StandardError]
    #
    def reraise
      yield
    rescue => exception
      ::Kernel.raise exception.class, exception.message, backtrace_cleaner.clean(exception.backtrace)
    end
  end
end
