# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Concern
      module InstanceMethods
        ##
        # @return [void]
        #
        # @internal
        #   NOTE: required by `.new` in `ClassMethods`.
        #
        def initialize(...)
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
          return true if self.class.method_defined?(method_name)
          return true if self.class.concerns.instance_method_defined?(method_name)

          if include_private
            return true if self.class.private_method_defined?(method_name)
            return true if self.class.concerns.private_instance_method_defined?(method_name)
          end

          false
        end

        ##
        # Commits config. In other words, includes `concerns` into the mixing class.
        # If `method` is still NOT defined, raises `NoMethodError`, otherwise - retries to call the `method`.
        #
        # @param method [Symbol]
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc, nil]
        # @return [void]
        #
        # @note Config commitment via a missing instance method is very rare. It is only possible when an instance is created without calling `.new` on a class.
        #
        # @internal
        #   IMPORTANT: `method_missing` MUST be thread-safe.
        #
        #   NOTE: `__send__` is used instead of `Support::SafeMethod` intentionally, since checking whether a method is defined is performed earlier by `Utils::Module.instance_method_defined?`.
        #
        #   TODO: Include `method` into trigger metadata.
        #
        #   IMPORTANT: Ruby 2.7 and Ruby 3.0+ invoke this `method_missing` differently, check the following files/links:
        #   - `lib/convenient_service/core/entities/config/entities/method_middlewares/entities/caller/commands/define_method_callers.rb`
        #   - https://gist.github.com/marian13/9c25041f835564e945d978839097d419
        #
        def method_missing(method, *args, **kwargs, &block)
          self.class.commit_config!(trigger: Constants::Triggers::INSTANCE_METHOD_MISSING)

          return ::ConvenientService.reraise { super } unless Utils::Module.instance_method_defined?(self.class, method, public: true, protected: false, private: false)

          return ::ConvenientService.reraise { super } if self.class.middlewares(method, scope: :instance).defined_without_super_method?

          ConvenientService.logger.debug { "[Core] Committed config for `#{self.class}` | Triggered by `method_missing` | Method: `##{method}`" }

          __send__(method, *args, **kwargs, &block)
        end
      end
    end
  end
end
