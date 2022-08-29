# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        ##
        #   specify {
        #     expect { method_class.cast(other, **options) }
        #       .to delegate_to(ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethod, :call)
        #       .with_arguments(other: other, options: options)
        #       .and_return_its_value
        #   }
        #
        #   { method_class.cast(other, **options) }
        #   # => block_expectation
        #
        #   ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Commands::CastMethod
        #   # => object
        #
        #   :call
        #   #=> method
        #
        #   (other: other, options: options)
        #   # => chain[:with]
        #
        #   and_return_its_value
        #   # => chain[:and_return_its_value]
        #
        # NOTE: A similar (with different behaviour) matcher exists in `saharspec'.
        # https://github.com/zverok/saharspec#send_messageobject-method-matcher
        #
        class DelegateTo
          ##
          # NOTE: `include ::RSpec::Expectations'.
          # - https://github.com/rspec/rspec-expectations/blob/v3.11.0/lib/rspec/expectations.rb
          # - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/expectations.rb#L60
          #
          include ::RSpec::Expectations

          ##
          # NOTE: `include ::RSpec::Matchers'.
          # - https://github.com/rspec/rspec-expectations/blob/v3.11.0/lib/rspec/matchers.rb
          # - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/matchers.rb
          #
          include ::RSpec::Matchers

          ##
          # NOTE: `include ::RSpec::Mocks::ExampleMethods'.
          # - https://github.com/rspec/rspec-mocks/blob/v3.11.1/lib/rspec/mocks/example_methods.rb
          # - https://github.com/rspec/rspec-mocks/blob/main/lib/rspec/mocks/example_methods.rb
          #
          include ::RSpec::Mocks::ExampleMethods

          ##
          #
          #
          def initialize(object, method)
            @object = object
            @method = method
          end

          ##
          #
          #
          def matches?(block_expectation)
            @block_expectation = block_expectation

            if used_with_arguments?
              ##
              # NOTE: RSpec `allow(object).to receive(method).with(*args, **kwargs)' does NOT support block.
              # https://github.com/rspec/rspec-mocks/issues/1182#issuecomment-679820352
              #
              # NOTE: RSpec `allow(object).to receive(method) do' does NOT support `and_call_original'.
              # https://github.com/rspec/rspec-mocks/issues/774#issuecomment-54245277
              #
              # NOTE: That is why `and_wrap_original' is used.
              # https://relishapp.com/rspec/rspec-mocks/docs/configuring-responses/wrapping-the-original-implementation
              #
              allow(object).to receive(method).and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
                ##
                # TODO: Provide customized error messages?
                # https://relishapp.com/rspec/rspec-expectations/docs/customized-message
                #
                expect(actual_args).to eq(expected_args)
                expect(actual_kwargs).to eq(expected_kwargs)
                expect(actual_block).to eq(expected_block)

                ##
                # NOTE: Imitates `and_call_original'.
                #
                original.call(*actual_args, **actual_kwargs, &actual_block)
              end
            else
              allow(object).to receive(method).and_call_original
            end

            ##
            # NOTE: Calls `block_expectation' before checking expections.
            #
            value = block_expectation.call

            expect(object).to have_received(method)

            expect(value).to eq(object.__send__(method, *args, **kwargs, &block)) if used_and_return_its_value?

            ##
            # IMPORTANT: A matcher should always return a boolean.
            # https://github.com/zverok/saharspec/blob/master/lib/saharspec/matchers/send_message.rb#L59
            #
            # NOTE: RSpec raises exception when any `expect' is NOT satisfied.
            # So, this `true' is returned only when all `expect' are successful.
            #
            true
          end

          ##
          # NOTE: Required by RSpec.
          # https://relishapp.com/rspec/rspec-expectations/v/3-8/docs/custom-matchers/define-a-matcher-supporting-block-expectations
          #
          def supports_block_expectations?
            true
          end

          ##
          #
          #
          def description
            "delegate to `#{printable_method}'"
          end

          ##
          # NOTE: `failure_message' is only called when `mathces?' returns `false'.
          # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers/MatcherProtocol#failure_message-instance_method
          #
          def failure_message
            "expected #{printable_block} to delegate to `#{printable_method}'"
          end

          ##
          # NOTE: `failure_message_when_negated' is only called when `mathces?' returns `false'.
          # https://rubydoc.info/github/rspec/rspec-expectations/RSpec/Matchers/MatcherProtocol#failure_message-instance_method
          #
          def failure_message_when_negated
            "expected #{printable_block} NOT to delegate to `#{printable_method}'"
          end

          def with_arguments(*args, **kwargs, &block)
            chain[:with_arguments] = {args: args, kwargs: kwargs, block: block}

            self
          end

          def and_return_its_value
            chain[:and_return_its_value] = true

            self
          end

          def printable_method
            @printable_method ||=
              case Utils::Object.resolve_type(object)
              when "class"
                "#{object}.#{method}"
              when "module"
                "#{object}.#{method}"
              when "instance"
                "#{object.class}##{method}"
              end
          end

          def printable_block
            @printable_block ||= block_expectation.source
          end

          private

          attr_reader :object, :method, :block_expectation

          def used_with_arguments?
            chain.key?(:with_arguments)
          end

          def used_and_return_its_value?
            chain.key?(:and_return_its_value)
          end

          def chain
            @chain ||= {}
          end

          def args
            @args ||= chain.dig(:with_arguments, :args) || []
          end

          alias_method :expected_args, :args

          def kwargs
            @kwargs ||= chain.dig(:with_arguments, :kwargs) || {}
          end

          alias_method :expected_kwargs, :kwargs

          ##
          # NOTE: `if defined?' is used in order to cache `nil' if needed.
          #
          def block
            return @block if defined? @block

            @block = chain.dig(:with_arguments, :block)
          end

          alias_method :expected_block, :block
        end
      end
    end
  end
end
