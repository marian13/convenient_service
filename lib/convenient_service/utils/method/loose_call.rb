# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Method
      class LooseCall < Support::Command
        ##
        # @example All possible parameters values in Ruby 2.7.
        #   class Example
        #     def m1(); end
        #     def m2(a); end
        #     def m3(a = 0); end
        #     def m4(a, b); end
        #     def m5(a, b = 1); end
        #     def m6(a = 0, b = 1); end
        #     def m7(*args); end
        #     def m8(a:); end
        #     def m9(a: 0); end
        #     def m10(a:, b:); end
        #     def m11(a:, b: 1); end
        #     def m12(a: 0, b: 1); end
        #     def m13(**kwargs); end
        #     def m14(&block); end
        #   end
        #
        #   object = Example.new
        #
        #   # def m1(); end
        #   p object.method(:m1).parameters
        #   # => []
        #
        #   # def m2(a); end
        #   p object.method(:m2).parameters
        #   # => [[:req, :a]]
        #
        #   # def m3(a = 0); end
        #   p object.method(:m3).parameters
        #   # => [[:opt, :a]]
        #
        #   # def m4(a, b); end
        #   p object.method(:m4).parameters
        #   # => [[:req, :a], [:req, :b]]
        #
        #   # def m5(a, b = 1); end
        #   p object.method(:m5).parameters
        #   # => [[:req, :a], [:opt, :b]]
        #
        #   # def m6(a = 0, b = 1); end
        #   p object.method(:m6).parameters
        #   # => [[:opt, :a], [:opt, :b]]
        #
        #   # def m7(*args); end
        #   p object.method(:m7).parameters
        #   # => [[:rest, :args]]
        #
        #   # def m8(a:); end
        #   p object.method(:m8).parameters
        #   # => [[:keyreq, :a]]
        #
        #   # def m9(a: 0); end
        #   p object.method(:m9).parameters
        #   # => [[:key, :a]]
        #
        #   # def m10(a:, b:); end
        #   p object.method(:m10).parameters
        #   # => [[:keyreq, :a], [:keyreq, :b]]
        #
        #   # def m11(a:, b: 1); end
        #   p object.method(:m11).parameters
        #   # => [[:keyreq, :a], [:key, :b]]
        #
        #   # def m12(a: 0, b: 1); end
        #   p object.method(:m12).parameters
        #   # => [[:key, :a], [:key, :b]]
        #
        #   # def m13(**kwargs); end
        #   p object.method(:m13).parameters
        #   # => [[:keyrest, :kwargs]]
        #
        #   # def m14(&block); end
        #   p object.method(:m14).parameters
        #   # => [[:block, :block]]
        #
        # @example All possible parameters values in Ruby 4.0.
        #   class Example
        #     def m1(); end
        #     def m2(a); end
        #     def m3(a = 0); end
        #     def m4(a, b); end
        #     def m5(a, b = 1); end
        #     def m6(a = 0, b = 1); end
        #     def m7(*args); end
        #     def m8(a:); end
        #     def m9(a: 0); end
        #     def m10(a:, b:); end
        #     def m11(a:, b: 1); end
        #     def m12(a: 0, b: 1); end
        #     def m13(**kwargs); end
        #     def m14(&block); end
        #   end
        #
        #   object = Example.new
        #
        #   # def m1(); end
        #   p object.method(:m1).parameters
        #   # => []
        #
        #   # def m2(a); end
        #   p object.method(:m2).parameters
        #   # => [[:req, :a]]
        #
        #   # def m3(a = 0); end
        #   p object.method(:m3).parameters
        #   # => [[:opt, :a]]
        #
        #   # def m4(a, b); end
        #   p object.method(:m4).parameters
        #   # => [[:req, :a], [:req, :b]]
        #
        #   # def m5(a, b = 1); end
        #   p object.method(:m5).parameters
        #   # => [[:req, :a], [:opt, :b]]
        #
        #   # def m6(a = 0, b = 1); end
        #   p object.method(:m6).parameters
        #   # => [[:opt, :a], [:opt, :b]]
        #
        #   # def m7(*args); end
        #   p object.method(:m7).parameters
        #   # => [[:rest, :args]]
        #
        #   # def m8(a:); end
        #   p object.method(:m8).parameters
        #   # => [[:keyreq, :a]]
        #
        #   # def m9(a: 0); end
        #   p object.method(:m9).parameters
        #   # => [[:key, :a]]
        #
        #   # def m10(a:, b:); end
        #   p object.method(:m10).parameters
        #   # => [[:keyreq, :a], [:keyreq, :b]]
        #
        #   # def m11(a:, b: 1); end
        #   p object.method(:m11).parameters
        #   # => [[:keyreq, :a], [:key, :b]]
        #
        #   # def m12(a: 0, b: 1); end
        #   p object.method(:m12).parameters
        #   # => [[:key, :a], [:key, :b]]
        #
        #   # def m13(**kwargs); end
        #   p object.method(:m13).parameters
        #   # => [[:keyrest, :kwargs]]
        #
        #   # def m14(&block); end
        #   p object.method(:m14).parameters
        #   # => [[:block, :block]]
        #
        class Signature
          ##
          # @!attribute [r] parameters
          #   @return [Array<Array<Symbol>>]
          #
          attr_reader :parameters

          ##
          # @param parameters [Array<Array<Symbol>>]
          # @return [void]
          #
          def initialize(parameters)
            @parameters = parameters
          end

          ##
          # @return [Array<Symbol>]
          #
          def args
            parsed_parameters[:args].to_a
          end

          ##
          # @return [Hash{Symbol => Object}]
          #
          def kwargs
            parsed_parameters[:kwargs].to_a
          end

          ##
          # @return [Symbol]
          #
          def kwargs_names
            @kwargs_names ||= kwargs.map { |_, name| name }
          end

          ##
          # @return [Boolean]
          #
          def args_rest?
            parsed_parameters.has_key?(:args_rest)
          end

          ##
          # @return [Boolean]
          #
          def kwargs_rest?
            parsed_parameters.has_key?(:kwargs_rest)
          end

          ##
          # @return [Boolean]
          #
          def block?
            parsed_parameters.has_key?(:block)
          end

          ##
          # @param regular_args [Array<Object>]
          # @return [Array<Object>]
          #
          def loose_args_from(regular_args)
            args_rest? ? regular_args : regular_args.take(args.size)
          end

          ##
          # @param regular_kwargs [Hash{Symbol => Object}]
          # @return [Hash{Symbol => Object}]
          #
          def loose_kwargs_from(regular_kwargs)
            kwargs_rest? ? regular_kwargs : regular_kwargs.slice(*kwargs_names)
          end

          ##
          # @param regular_block [Proc, nil]
          # @return [Proc, nil]
          #
          def loose_block_from(regular_block)
            block? ? regular_block : nil
          end

          private

          ##
          # @return [Hash{Symbol => Object}]
          #
          def parsed_parameters
            @parsed_parameters ||=
              parameters.each_with_object({}) do |parameter, hash|
                case parameter.first
                when :req, :opt
                  (hash[:args] ||= []) << parameter
                when :keyreq, :key
                  (hash[:kwargs] ||= []) << parameter
                when :block
                  hash[:block] = parameter
                when :rest
                  hash[:args_rest] = true
                when :keyrest
                  hash[:kwargs_rest] = true
                end
              end
          end
        end

        ##
        # @!attribute [r] method
        #   @return [String, Symbol]
        #
        attr_reader :method

        ##
        # @!attribute [r] args
        #   @return [Array<Object>]
        #
        attr_reader :args

        ##
        # @!attribute [r] kwargs
        #   @return [Hash{Symbol => Object}]
        #
        attr_reader :kwargs

        ##
        # @!attribute [r] block
        #   @return [Proc, nil]
        #
        attr_reader :block

        ##
        # @param method [Symbol, String]
        # @param args [Array<Object>]
        # @param kwargs [Hash{Symbol => Object}]
        # @param block [Proc, nil]
        # @return [void]
        #
        def initialize(method, *args, **kwargs, &block)
          @method = method
          @args = args
          @kwargs = kwargs
          @block = block
        end

        ##
        # @return [Object] Can be any type.
        #
        # @internal
        #   NOTE: Ruby 2.7 sometimes passes `kwargs` as `args`. Look for `ConvenientService::Dependencies.ruby.version > 3.0` in `spec/e2e/loose_method_steps_spec.rb` for examples.
        #
        def call
          method.call(
            *signature.loose_args_from(args),
            **signature.loose_kwargs_from(kwargs),
            &signature.loose_block_from(block)
          )
        end

        private

        ##
        # @return [Signature]
        #
        def signature
          @signature ||= Signature.new(parameters)
        end

        ##
        # @return [Array<Array<Symbol>>]
        #
        def parameters
          @parameters ||= method.parameters
        end
      end
    end
  end
end
