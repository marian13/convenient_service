# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        module Entities
          class InstanceProxy
            ##
            # @api private
            #
            # @param target [Object] Can be any type.
            # @return [void]
            #
            def initialize(target:)
              @__convenient_service_instance_proxy_target__ = target
            end

            ##
            # @api public
            #
            # @return [Object] Can be any type.
            #
            def instance_proxy_target
              @__convenient_service_instance_proxy_target__
            end

            ##
            # @return [Class]
            #
            alias_method :instance_proxy_class, :class

            ##
            # @return [Class]
            #
            def class
              instance_proxy_target.class
            end

            ##
            # @api public
            #
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(instance_proxy_class)

              return false if instance_proxy_target != other.instance_proxy_target

              true
            end

            private

            ##
            # @see https://thoughtbot.com/blog/always-define-respond-to-missing-when-overriding
            # @see https://blog.marc-andre.ca/2010/11/15/methodmissing-politely
            # @see https://stackoverflow.com/a/3304683/12201472
            #
            # @param method_name [Symbol, String]
            # @param include_private [Boolean]
            # @return [Boolean]
            #
            # @internal
            #   IMPORTANT: `respond_to_missing?` is like `initialize`. It is always `private`.
            #   - https://ruby-doc.org/core-2.7.0/Object.html#method-i-respond_to_missing-3F
            #   - https://github.com/ruby/spec/blob/master/language/def_spec.rb#L65
            #
            def respond_to_missing?(method_name, include_private = false)
              instance_proxy_target.respond_to?(method_name, include_private)
            end

            ##
            # @return [Object] Can be any type.
            #
            def method_missing(...)
              ::ConvenientService.reraise { instance_proxy_target.public_send(...) }
            end
          end
        end
      end
    end
  end
end
