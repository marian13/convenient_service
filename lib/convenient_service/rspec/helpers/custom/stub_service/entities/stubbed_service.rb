# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class StubService < Support::Command
          module Entities
            ##
            # TODO: Specs.
            #
            class StubbedService < Support::Command
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

              def initialize(service_class:)
                @service_class = service_class
              end

              def with_arguments(*args, **kwargs, &block)
                chain[:with_arguments] = {args: args, kwargs: kwargs, block: block}

                self
              end

              def to(result_spec)
                @result_spec = result_spec

                service_class.commit_config!

                if used_with_arguments?
                  allow(service_class).to receive(:result).and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
                    expect(actual_args).to eq(expected_args)
                    expect(actual_kwargs).to eq(expected_kwargs)
                    expect(actual_block).to eq(expected_block)

                    result_value
                  end
                else
                  allow(service_class).to receive(:result).and_return(result_value)
                end
              end

              private

              attr_reader :service_class, :result_spec

              def result_value
                @result_value ||= result_spec.for(service_class).calculate_value
              end

              def used_with_arguments?
                chain.key?(:with_arguments)
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
            end
          end
        end
      end
    end
  end
end
