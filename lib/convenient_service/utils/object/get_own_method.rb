# frozen_string_literal: true

module ConvenientService
  module Utils
    module Object
      class GetOwnMethod < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @!attribute [r] method_name
        #   @return [Symbol, String]
        #
        attr_reader :method_name

        ##
        # @!attribute [r] private
        #   @return [Boolean]
        #
        attr_reader :private

        ##
        # @param object [Object] Can be any type.
        # @param method_name [Symbol, String]
        # @param private [Boolean]
        #
        def initialize(object, method_name, private: false)
          @object = object
          @method_name = method_name
          @private = private
        end

        ##
        # @return [Class]
        #
        # @internal
        #   NOTE: `own_method.bind(object).call` is logically the same as `own_method.bind_call(object)`.
        #   - https://ruby-doc.org/core-2.7.1/UnboundMethod.html#method-i-bind_call
        #   - https://blog.saeloun.com/2019/10/17/ruby-2-7-adds-unboundmethod-bind_call-method.html
        #
        def call
          own_method = Utils::Module.get_own_instance_method(object.class, method_name, private: private)

          return unless own_method

          own_method.bind(object)
        end
      end
    end
  end
end
