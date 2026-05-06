# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveInlineServices
        module Entities
          ##
          # @internal
          #   TODO: Specs.
          #
          class Proxy
            ##
            # @param chain [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @return [void]
            #
            def initialize(chain: {}, &block)
              @chain = chain

              if block
                chain[:block] = block

                define
              end
            end

            ##
            # @return [Boolean]
            #
            def defined?
              chain.has_key?(:defined)
            end

            ##
            # @return [Boolean]
            #
            def define
              return false if self.defined?

              klass.include config

              variables.each_pair { |key, value| klass.define_method(key) { value } }

              klass.class_exec(arguments, &block)

              mark_as_defined!

              true
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveInlineServices::Entities::Proxy]
            #
            def with_arguments(...)
              assert_not_defined!

              chain[:arguments] = Support::Arguments.new(...)

              self
            end

            ##
            # @param variables [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveInlineServices::Entities::Proxy]
            #
            def with_variables(**variables)
              assert_not_defined!

              chain[:variables] = variables

              self
            end

            ##
            # @param config [ConvenientService::Config]
            # @return [ConvenientService::Service::Plugins::CanHaveInlineServices::Entities::Proxy]
            #
            def with_config(config)
              assert_not_defined!

              chain[:config] = config

              self
            end

            ##
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def result(&block)
              if block
                assert_not_defined!

                chain[:block] = block

                define
              end

              klass.result
            end

            ##
            # @param block [Proc, nil]
            # @return [Class<ConvenientService::Service>]
            #
            def to_class(&block)
              if block
                assert_not_defined!

                chain[:block] = block

                define
              end

              klass
            end

            ##
            # @return [Class<ConvenientService::Service>]
            #
            alias_method :service, :to_class

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if chain != other.chain

              true
            end

            protected

            ##
            # @!attribute [r] value
            #   @return [Hash{Symbol => Object}]
            #
            attr_reader :chain

            private

            ##
            # @return [Class]
            #
            def klass
              @klass ||= ::Class.new
            end

            ##
            # @return [ConvenientService::Support::Arguments]
            #
            def arguments
              chain[:arguments] || Support::Arguments.null_arguments
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def variables
              chain[:variables] || {}
            end

            ##
            # @return [ConvenientService::Config]
            #
            def config
              chain[:config] || ::ConvenientService::Standard::Config
            end

            ##
            # @return [Proc]
            #
            def block
              chain[:block] || proc {}
            end

            ##
            # @return [void]
            # @raise [ConvenientService::Service::Plugins::CanHaveInlineServices::Exceptions::InlineServiceIsAlreadyDefined]
            #
            def assert_not_defined!
              ::ConvenientService.raise Exceptions::InlineServiceIsAlreadyDefined if self.defined?
            end

            ##
            # @return [void]
            #
            def mark_as_defined!
              chain[:defined] = true
            end
          end
        end
      end
    end
  end
end
