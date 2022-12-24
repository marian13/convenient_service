# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Commands
            class ApplyStubToTrackDelegations < Support::Command
              ##
              # @internal
              #   NOTE: `include ::RSpec::Mocks::ExampleMethods`.
              #   - https://github.com/rspec/rspec-mocks/blob/v3.11.1/lib/rspec/mocks/example_methods.rb
              #   - https://github.com/rspec/rspec-mocks/blob/main/lib/rspec/mocks/example_methods.rb
              #
              include ::RSpec::Mocks::ExampleMethods

              ##
              # @return [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
              #
              attr_reader :matcher

              ##
              # @param matcher [ConvenientService::RSpec::Matchers::Custom::DelegateTo]
              # @return [void]
              #
              def initialize(matcher:)
                @matcher = matcher
              end

              def call
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
                allow(matcher.object).to receive(matcher.method).and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
                  ##
                  # TODO: Add backtrace for easier reason tracing.
                  #
                  matcher.delegations << Entities::Delegation.new(
                    object: matcher.object,
                    method: matcher.method,
                    args: actual_args,
                    kwargs: actual_kwargs,
                    block: actual_block
                  )

                  ##
                  # NOTE: Imitates `and_call_original`.
                  #
                  original.call(*actual_args, **actual_kwargs, &actual_block) if matcher.should_call_original?
                end
              end
            end
          end
        end
      end
    end
  end
end
