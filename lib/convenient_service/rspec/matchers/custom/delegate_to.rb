# frozen_string_literal: true

##
# IMPORTANT: This matcher has a dedicated end-user doc. Do NOT forget to update it when needed.
# https://github.com/marian13/convenient_service_docs/blob/main/docs/api/tests/rspec/matchers/delegate_to.mdx
#
# TODO: Refactor into composition:
#   - Ability to compose when `delegate_to` is used `without_arguments`.
#   - Ability to compose when `delegate_to` is used `with_arguments`.
#   - Ability to compose when `delegate_to` is used `and_return_its_value`.
#
# TODO: Refactor to NOT use `expect` inside this matcher.
# This way the matcher will return true or false, but never raise exceptions (descendant of Exception, not StandardError).
# Then it will be easier to developer a fully comprehensive spec suite for `delegate_to`.
#
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
        # NOTE: A similar (with different behaviour) matcher exists in `saharspec`.
        # https://github.com/zverok/saharspec#send_messageobject-method-matcher
        #
        class DelegateTo
          ##
          # NOTE: `include ::RSpec::Expectations`.
          # - https://github.com/rspec/rspec-expectations/blob/v3.11.0/lib/rspec/expectations.rb
          # - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/expectations.rb#L60
          #
          include ::RSpec::Expectations

          ##
          # NOTE: `include ::RSpec::Matchers`.
          # - https://github.com/rspec/rspec-expectations/blob/v3.11.0/lib/rspec/matchers.rb
          # - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/matchers.rb
          #
          include ::RSpec::Matchers

          ##
          # NOTE: `include ::RSpec::Mocks::ExampleMethods`.
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

            ##
            # TODO: Support multiple `with_arguments` calls.
            #
            if used_with_arguments?
              ##
              # NOTE: RSpec `allow(object).to receive(method).with(*args, **kwargs)` does NOT support block.
              # https://github.com/rspec/rspec-mocks/issues/1182#issuecomment-679820352
              #
              # NOTE: RSpec `allow(object).to receive(method) do` does NOT support `and_call_original`.
              # https://github.com/rspec/rspec-mocks/issues/774#issuecomment-54245277
              #
              # NOTE: That is why `and_wrap_original` is used.
              # https://relishapp.com/rspec/rspec-mocks/docs/configuring-responses/wrapping-the-original-implementation
              #
              allow(object).to receive(method).and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
                actual_arguments_collection << [actual_args, actual_kwargs, actual_block]

                ##
                # NOTE: Imitates `and_call_original`.
                #
                original.call(*actual_args, **actual_kwargs, &actual_block)
              end
            else
              allow(object).to receive(method).and_call_original
            end

            ##
            # NOTE: Calls `block_expectation` before checking expections.
            #
            value = block_expectation.call

            ##
            # NOTE: If this expectation fails, it means `delegate_to` is NOT met.
            #
            expect(object).to have_received(method).at_least(1) unless used_with_arguments?

            ##
            # IMPORTANT: `and_return_its_value` works only when `delegate_to` checks a pure function.
            #
            # For example (1):
            #   def require_dependencies_pure
            #     RequireDependenciesPure.call
            #   end
            #
            #   class RequireDependenciesPure
            #     def self.call
            #       dependencies.require!
            #
            #       true
            #     end
            #   end
            #
            #   # Works since `RequireDependenciesPure.call` always returns `true`.
            #   specify do
            #     expect { require_dependencies_pure }
            #       .to delegate_to(RequireDependenciesPure, :call)
            #       .and_return_its_value
            #   end
            #
            # Example (2):
            #   def require_dependencies_not_pure
            #     RequireDependenciesNotPure.call
            #   end
            #
            #   class RequireDependenciesNotPure
            #     def self.call
            #       return false if dependencies.required?
            #
            #       dependencies.require!
            #
            #       true
            #     end
            #   end
            #
            #   # Does NOT work since `RequireDependenciesNotPure.call` returns `true` for the first time and `false` for the subsequent call.
            #   specify do
            #     expect { require_dependencies_not_pure }
            #       .to delegate_to(RequireDependenciesNotPure, :call)
            #       .and_return_its_value
            #   end
            #
            # NOTE: If this expectation fails, it means `and_return_its_value` is NOT met.
            #
            expect(value).to eq(object.__send__(method, *args, **kwargs, &block)) if used_and_return_its_value?

            ##
            # IMPORTANT: A matcher should always return a boolean.
            # https://github.com/zverok/saharspec/blob/master/lib/saharspec/matchers/send_message.rb#L59
            #
            # NOTE: RSpec raises exception when any `expect` is NOT satisfied.
            # So, this `true` is returned only when all `expect` are successful.
            #
            if used_with_arguments?
              actual_arguments_collection.any? do |(actual_args, actual_kwargs, actual_block)|
                actual_args == expected_args && actual_kwargs == expected_kwargs && actual_block == expected_block
              end
            else
              true
            end
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
            "delegate to `#{printable_method}`"
          end

          def failure_message
            if used_with_arguments?
              "expected `#{printable_block_expectation}` to delegate to `#{printable_method}` with expected arguments at least once, but it didn't."
            else
              "expected `#{printable_block_expectation}` to delegate to `#{printable_method}` at least once, but it didn't."
            end
          end

          ##
          # IMPORTANT: `failure_message_when_negated` is NOT supported yet.
          #

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
              when "class", "module"
                "#{object}.#{method}"
              when "instance"
                "#{object.class}##{method}"
              end
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
          # NOTE: `if defined?` is used in order to cache `nil` if needed.
          #
          def block
            return @block if defined? @block

            @block = chain.dig(:with_arguments, :block)
          end

          alias_method :expected_block, :block

          def actual_arguments_collection
            @actual_arguments_collection ||= []
          end

          ##
          # NOTE: An example of how RSpec extracts block source, but they marked it as private.
          # https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
          #
          # TODO: `printable_block_expectation` when `method_source` is available.
          # https://github.com/banister/method_source
          #
          # def printable_block_expectation
          #   @printable_block_expectation ||= block_expectation.source
          # end
          #
          def printable_block_expectation
            @printable_block_expectation ||= "{ ... }"
          end
        end
      end
    end
  end
end
