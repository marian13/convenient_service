# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class DelegateTo
          module Entities
            module SubMatchers
              class Arguments < SubMatchers::Base
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
                    # @return [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
                    #
                    attr_reader :matcher

                    ##
                    # @param matcher [ConvenientService::RSpec::Matchers::Classes::DelegateTo]
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
                      # TODO: Check whether `matcher.object.frozen?` in order to show more explanatory exception instead of the following (provide an example of how to avoid it in the exception message):
                      #   ArgumentError:
                      #     Cannot proxy frozen objects, rspec-mocks relies on proxies for method stubbing and expectations
                      #
                      allow(matcher.inputs.object).to receive(matcher.inputs.method).and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
                        ##
                        # TODO: Add backtrace for easier reason tracing.
                        #
                        matcher.outputs.delegations << Entities::Delegation.new(
                          object: matcher.inputs.object,
                          method: matcher.inputs.method,
                          args: actual_args,
                          kwargs: actual_kwargs,
                          block: actual_block
                        )

                        ##
                        # NOTE: Imitates `and_call_original`.
                        # TODO: What to do when `original.call` raises an exception?
                        #
                        original.call(*actual_args, **actual_kwargs, &actual_block) if matcher.inputs.should_call_original?
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
