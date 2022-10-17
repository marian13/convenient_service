# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class BeError
            def matches?(result)
              @result = result

              rules = []

              rules << ->(result) { result.class.include?(ConvenientService::Service::Plugins::HasResult::Entities::Result::Concern) }
              rules << ->(result) { result.error? }
              rules << ->(result) { result.service.instance_of?(service_class) } if used_of?
              rules << ->(result) { result.message == message } if used_message?
              rules << ->(result) { result.code == code } if used_code?

              condition = ConvenientService::Utils::Proc.conjunct(rules)

              condition.call(result)
            end

            def with_message(message)
              chain[:message] = message

              self
            end

            def and_message(message)
              chain[:message] = message

              self
            end

            def with_code(code)
              chain[:code] = code

              self
            end

            def and_code(code)
              chain[:code] = code

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

              parts << "be an `error`"
              parts << "of `#{service_class}`" if used_of?
              parts << "with message `#{message}`" if used_message?
              parts << "with code `#{code}`" if used_code?
              parts << "\n\n"
              parts << "got `#{result.status}`"
              parts << "of `#{result.service.class}`" if used_of?
              parts << "with message `#{result.message}`" if used_message?
              parts << "with code `#{result.code}`" if used_code?

              parts.join(" ")
            end

            def failure_message
              ##
              # TODO: got text after expect text.
              #
              parts = []

              parts << "expected that `#{result}` would be an `error`"
              parts << "of `#{service_class}`" if used_of?
              parts << "with message `#{message}`" if used_message?
              parts << "with code `#{code}`" if used_code?
              parts << "\n\n"
              parts << "got `#{result.status}`"
              parts << "of `#{result.service.class}`" if used_of?
              parts << "with message `#{result.message}`" if used_message?
              parts << "with code `#{result.code}`" if used_code?

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

              parts << "expected that #{result} would NOT be an `error`"
              parts << "of `#{service_class}`" if used_of?
              parts << "with message `#{message}`" if used_message?
              parts << "with code `#{code}`" if used_code?
              parts << "\n\n"
              parts << "got `#{result.status}`"
              parts << "of `#{result.service.class}`" if used_of?
              parts << "with message `#{result.message}`" if used_message?
              parts << "with code `#{result.code}`" if used_code?

              parts.join(" ")
            end

            private

            attr_reader :result

            def used_message?
              chain.key?(:message)
            end

            def used_code?
              chain.key?(:code)
            end

            def used_of?
              chain.key?(:service_class)
            end

            def chain
              @chain ||= {}
            end

            def message
              @message ||= chain[:message] || ""
            end

            def code
              @code ||= chain[:code] || ""
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
