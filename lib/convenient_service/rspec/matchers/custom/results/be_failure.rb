# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeFailure
            def matches?(result)
              @result = result

              rules = []

              ##
              # TODO: Remove `|| result.is_a?(ConvenientService::V1::Plugins::HasResult::Entities::Result)` when V1 is dropped.
              #
              rules << ->(result) { result.class.include?(ConvenientService::Service::Plugins::HasResult::Entities::Result::Concern) || result.is_a?(ConvenientService::V1::Plugins::HasResult::Entities::Result) }
              rules << ->(result) { result.failure? }
              rules << ->(result) { result.service.instance_of?(service_class) } if used_of?
              rules << ->(result) { result.data == data } if used_data?

              condition = ConvenientService::Utils::Proc.conjunct(rules)

              condition.call(result)
            end

            def with_data(data)
              chain[:data] = data

              self
            end

            def of(service_class)
              chain[:service_class] = service_class

              self
            end

            def description
              ##
              # TODO: of
              #
              parts = []

              parts << "be a `failure`"
              parts << "of `#{service_class}`" if used_of?
              parts << "with data `#{data}`" if used_data?
              parts << "\n\n"
              parts << "got `#{result.status}`"
              parts << "of `#{result.service.class}`" if used_of?
              parts << "with data `#{result.data.to_h}`" if used_data?

              parts.join(" ")
            end

            def failure_message
              ##
              # TODO: got text after expect text.
              #
              parts = []

              parts << "expected that `#{result}` would be a `failure`"
              parts << "of `#{service_class}`" if used_of?
              parts << "with data `#{data}`" if used_data?
              parts << "\n\n"
              parts << "got `#{result.status}`"
              parts << "of `#{result.service.class}`" if used_of?
              parts << "with data `#{result.data.to_h}`" if used_data?

              parts.join(" ")
            end

            ##
            # https://relishapp.com/rspec/rspec-expectations/v/3-11/docs/custom-matchers/define-a-custom-matcher#overriding-the-failure-message-when-negated
            #
            def failure_message_when_negated
              ##
              # TODO: got text after expect text.
              #
              parts = []

              parts << "expected that #{result} would NOT be a `failure`"
              parts << "of `#{service_class}`" if used_of?
              parts << "with data `#{data}`" if used_data?
              parts << "\n\n"
              parts << "got `#{result.status}`"
              parts << "of `#{result.service.class}`" if used_of?
              parts << "with data `#{result.data.to_h}`" if used_data?

              parts.join(" ")
            end

            private

            attr_reader :result

            def used_data?
              chain.key?(:data)
            end

            def used_of?
              chain.key?(:service_class)
            end

            def chain
              @chain ||= {}
            end

            def data
              @data ||= chain[:data] || {}
            end

            def service_class
              return @service_class if defined? @service_class

              @service_class = chain[:service_class]
            end
          end
        end
      end
    end
  end
end
