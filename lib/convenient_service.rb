# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
#   Convenient Service Config.
#
require_relative "convenient_service/config"

##
# @internal
#   Convenient Service Default Plugins/Extensions.
#
require_relative "convenient_service/common"

##
# @internal
#   Convenient Service Service.
#
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

##
# Convenient Service module/namespace.
#
# @api public
# @since 1.0.0
# @note This module is NOT expected to be included or extended by the end-user classes and modules. See {ConvenientService::Standard::Config} as the main entrypoint.
#
# @example How to load `CS` - Convenient Service alias?
#   require "convenient_service/extras/alias"
#
#   class Service
#     include CS::Standard::Config
#
#     def result
#       success
#     end
#   end
#
# @example How to load RSpec extensions?
#   ##
#   # RSpec extensions expected to be required from RSpec entry points like `spec_helper.rb`.
#   #
#   require "convenient_service/extras/rspec"
#
#   ##
#   # In some spec file like `service_spec.rb`
#   #
#   RSpec.describe Service do
#     include ConvenientService::RSpec::Matchers::Results
#
#     it "returns success" do
#       expect(Service.result).to be_success
#     end
#   end
#
#   ##
#   # In some spec file like `other_service_spec.rb`
#   #
#   RSpec.describe OtherService do
#     include ConvenientService::RSpec::Helpers::StubService
#
#     before do
#       stub_service(Service).to return_success.with_data(foo: :bar)
#     end
#
#     # ...
#   end
#
# @example How to load `active_model_validations` standard config option?
#   require "convenient_service/extras/standard/config/options/active_model_validations"
#
#   class Service
#     include ConvenientService::Standard::Config.with(:active_model_validations)
#
#     attr_reader :foo
#
#     validates :foo, presence: true
#
#     def initialize(foo:)
#       @foo = foo
#     end
#
#     def result
#       success
#     end
#   end
#
#   Service.result(foo: nil)
#   # => <Service::Result status: :error, data_keys: [:foo], message: "foo can't be blank">
#
#   Service.result(foo: :bar)
#   # => <Service::Result status: :success>
#
# @example How to load `amazing_print_inspect` standard config option?
#   require "convenient_service/extras/standard/config/options/amazing_print_inspect"
#
#   class Service
#     include ConvenientService::Standard::Config.with(:amazing_print_inspect)
#
#     def result
#       success
#     end
#   end
#
#   ap Service.result
#   # {
#   #     :ConvenientService => {
#   #          :entity => "Result",
#   #         :service => "Service",
#   #          :status => :success
#   # }
#
# @example How to load `awesome_print_inspect` standard config option?
#   require "convenient_service/extras/standard/config/options/awesome_print_inspect"
#
#   class Service
#     include ConvenientService::Standard::Config.with(:awesome_print_inspect)
#
#     def result
#       success
#     end
#   end
#
#   ap Service.result
#   # {
#   #     :ConvenientService => {
#   #          :entity => "Result",
#   #         :service => "Service",
#   #          :status => :success
#   # }
#
# @example How to load `dry_initializer` standard config option?
#   require "convenient_service/extras/standard/config/options/dry_initializer"
#
#   class Service
#     include ConvenientService::Standard::Config.with(:dry_initializer)
#
#     option :foo
#
#     def result
#       success
#     end
#   end
#
# @example How to load `memo_wise` standard config option?
#   require "convenient_service/extras/standard/config/options/memo_wise"
#
#   class Service
#     include ConvenientService::Standard::Config.with(:memo_wise)
#
#     def result
#       success(foo: foo, bar: bar)
#     end
#
#     private
#
#     memo_wise \
#       def foo
#         :foo
#       end
#
#     memo_wise \
#       def bar
#         :bar
#       end
#   end
#
module ConvenientService
  class << self
    ##
    # Returns `true` when Convenient Service is in debug mode. In other words `$CONVENIENT_SERVICE_DEBUG` env variable is set to `true`.
    #
    # @api private
    # @since 1.0.0
    # @return [Boolean]
    #
    def debug?
      Dependencies.debug?
    end

    ##
    # Returns `true` when Convenient Service is in benchmark mode. In other words `$CONVENIENT_SERVICE_BENCHMARK` env variable is set to `true`.
    #
    # @api private
    # @since 1.0.0
    # @return [Boolean]
    #
    def benchmark?
      Dependencies.benchmark?
    end

    ##
    # Returns `true` when Convenient Service is in CI mode. In other words `$CONVENIENT_SERVICE_CI` env variable is set to `true`.
    #
    # @api private
    # @since 1.0.0
    # @return [Boolean]
    #
    def ci?
      Dependencies.ci?
    end

    ##
    # Returns Convenient Service internal logger, that is an instance of Ruby stdlib logger.
    # Useful for debugging Convenient Service internals.
    #
    # @api public
    # @since 1.0.0
    # @return [ConvenientService::Logger]
    #
    # @see https://github.com/ruby/logger
    # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html
    #
    # @example Set log level.
    #   ConvenientService.logger.level = Logger::DEBUG
    #
    def logger
      Logger.instance
    end

    ##
    # Returns Convenient Service root folder. Inspired by `Rails.root`.
    # For example, it may return something like: `/Users/marian/.asdf/installs/ruby/2.7.0/lib/ruby/gems/2.7.0/gems/convenient_service-1.0.0`.
    #
    # @api public
    # @since 1.0.0
    # @return [Pathname]
    #
    # @see https://ruby-doc.org/core-2.7.1/Kernel.html#method-i-__dir__
    # @see https://api.rubyonrails.org/classes/Rails.html#method-c-root
    #
    def root
      @root ||= ::Pathname.new(::File.expand_path(::File.join(__dir__, "..")))
    end

    ##
    # Returns Convenient Service lib folder.
    # For example, it may return something like: `/Users/marian/.asdf/installs/ruby/2.7.0/lib/ruby/gems/2.7.0/gems/convenient_service-1.0.0/lib`.
    #
    # @api private
    # @since 1.0.0
    # @return [Pathname]
    #
    def lib_root
      @lib_root ||= ::Pathname.new(::File.join(root, "lib"))
    end

    ##
    # Returns Convenient Service examples folder.
    # For example, it may return something like: `/Users/marian/.asdf/installs/ruby/2.7.0/lib/ruby/gems/2.7.0/gems/convenient_service-1.0.0/lib/convenient_service/examples`.
    #
    # @api private
    # @since 1.0.0
    # @return [Pathname]
    #
    def examples_root
      @examples_root ||= ::Pathname.new(::File.join(root, "lib", "convenient_service", "examples"))
    end

    ##
    # Returns Convenient Service specs folder.
    # For example, it may return something like: `/Users/marian/.asdf/installs/ruby/2.7.0/lib/ruby/gems/2.7.0/gems/convenient_service-1.0.0/spec`.
    #
    # @api private
    # @since 1.0.0
    # @return [Pathname]
    #
    def spec_root
      @spec_root ||= ::Pathname.new(::File.join(root, "spec"))
    end

    ##
    # Returns Convenient Service backtrace cleaner (has similar interface to Rails v8.0.2 backtrace cleaner).
    # Useful for debugging Convenient Service internals.
    #
    # @api public
    # @since 1.0.0
    # @return [ConvenientService::Support::BacktraceCleaner]
    #
    # @see https://api.rubyonrails.org/v8.0.2/classes/ActiveSupport/BacktraceCleaner.html
    # @see https://github.com/rails/rails/blob/v8.0.2/activesupport/lib/active_support/backtrace_cleaner.rb
    #
    # @example How to remove all backtrace cleaner filters?
    #   ConvenientService.backtrace_cleaner.remove_filters!
    #
    # @example How to remove all backtrace cleaner silencers?
    #   ConvenientService.backtrace_cleaner.remove_silencers!
    #
    # @example How to add backtrace cleaner stdlib silencer?
    #   ConvenientService.backtrace_cleaner.add_stdlib_silencer
    #
    # @example How to add backtrace cleaner Convenient Service silencer?
    #   ConvenientService.backtrace_cleaner.add_convenient_service_silencer
    #
    # @example Hot to clean exception backtrace?
    #   begin
    #     16 / 0
    #   rescue => exception
    #   end
    #
    #   ConvenientService.backtrace_cleaner.clean(exception.backtrace)
    #
    def backtrace_cleaner
      @backtrace_cleaner ||= Support::BacktraceCleaner.new
    end

    ##
    # Raises Convenient Service exceptions.
    # Cleans exception backtrace with `ConvenientService.backtrace_cleaner.clean` before delegating to `Kernel.raise`.
    #
    # @api public
    # @since 1.0.0
    # @param original_exception [StandardError]
    # @raise [StandardError]
    #
    # @note Expected to be used from Convenient Service plugins.
    #
    # @internal
    #   NOTE: `rescue ::StandardError => exception` is the same as `rescue => exception`.
    #
    def raise(original_exception)
      ::Kernel.raise original_exception
    rescue => exception
      ::Kernel.raise exception.class, exception.message, backtrace_cleaner.clean(exception.backtrace), cause: exception.cause
    end

    ##
    # Re-raises Convenient Service exceptions.
    # Cleans exception backtrace with `ConvenientService.backtrace_cleaner.clean` before delegating to `Kernel.raise`.
    #
    # @api public
    # @since 1.0.0
    # @return [Object] Can be any type.
    # @raise [StandardError]
    #
    # @note Expected to be used from Convenient Service plugins.
    #
    # @internal
    #   NOTE: `rescue ::StandardError => exception` is the same as `rescue => exception`.
    #
    def reraise
      yield
    rescue => exception
      ::Kernel.raise exception.class, exception.message, backtrace_cleaner.clean(exception.backtrace), cause: exception.cause
    end
  end
end

require_relative "convenient_service/jruby"
