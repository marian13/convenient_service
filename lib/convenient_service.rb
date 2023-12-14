# frozen_string_literal: true

##
# @internal
#   Convenient Service Dependencies.
#
require_relative "convenient_service/dependencies"

##
# @internal
#   Convenient Service Inner Tools and Utilities.
#
require_relative "convenient_service/logger"
require_relative "convenient_service/exception"
require_relative "convenient_service/support"
require_relative "convenient_service/utils"
require_relative "convenient_service/version"

##
# @internal
#   Convenient Service Core.
#
require_relative "convenient_service/core"

##
# @internal
#   Convenient Service Default Plugins/Extensions.
#
require_relative "convenient_service/common"
require_relative "convenient_service/service"

##
# @internal
#   Convenient Service Feature.
#
require_relative "convenient_service/feature"

##
# @internal
#   Convenient Service Aliases.
#
require_relative "convenient_service/aliases"

module ConvenientService
  class << self
    ##
    # @api public
    #
    # @return [ConvenientService::Logger]
    #
    def logger
      Logger.instance
    end

    ##
    # Returns Convenient Service root folder. Inspired by `Rails.root`.
    # For example, it may return something like: `/Users/user/.asdf/installs/ruby/2.7.0/lib/ruby/gems/2.7.0/gems/convenient_service-0.16.0`.
    #
    # @api public
    #
    # @return [Pathname]
    #
    # @see https://ruby-doc.org/core-2.7.1/Kernel.html#method-i-__dir__
    # @see https://api.rubyonrails.org/classes/Rails.html#method-c-root
    #
    def root
      @root ||= ::Pathname.new(::File.expand_path(::File.join(__dir__, "..")))
    end

    ##
    # Returns Convenient Service Examples folder.
    # For example, it may return something like: `/Users/user/.asdf/installs/ruby/2.7.0/lib/ruby/gems/2.7.0/gems/convenient_service-0.16.0/lib/convenient_service/examples`.
    #
    # @api private
    #
    # @return [Pathname]
    #
    def examples_root
      @examples_root ||= ::Pathname.new(::File.join(root, "lib", "convenient_service", "examples"))
    end

    ##
    # @api public
    #
    # @return [ConvenientService::Support::BacktraceCleaner]
    #
    def backtrace_cleaner
      @backtrace_cleaner ||= Support::BacktraceCleaner.new
    end

    ##
    # @api public
    #
    # @param original_exception [StandardError]
    #
    # @raise [StandardError]
    #
    # @internal
    #   NOTE: `rescue ::StandardError => exception` is the same as `rescue => exception`.
    #   TODO: Specs.
    #
    def raise(original_exception)
      ::Kernel.raise original_exception
    rescue => exception
      ::Kernel.raise exception.class, exception.message, backtrace_cleaner.clean(exception.backtrace), cause: exception.cause
    end

    ##
    # @api public
    #
    # @return [Object] Can be any type.
    #
    # @raise [StandardError]
    #
    # @internal
    #   NOTE: `rescue ::StandardError => exception` is the same as `rescue => exception`.
    #   TODO: Specs.
    #
    def reraise
      yield
    rescue => exception
      ::Kernel.raise exception.class, exception.message, backtrace_cleaner.clean(exception.backtrace), cause: exception.cause
    end
  end
end
