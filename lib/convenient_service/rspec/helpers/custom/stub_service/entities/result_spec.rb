# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        ##
        # TODO: Specs.
        #
        class StubService < Support::Command
          module Entities
            class ResultSpec
              def initialize(status:, service_class: nil, chain: {})
                @status = status
                @service_class = service_class
                @chain = chain
              end

              def for(service_class)
                self.class.new(status: status, service_class: service_class, chain: chain)
              end

              def with_data(data)
                chain[:data] = data

                self
              end

              def with_message(message)
                chain[:message] = message

                self
              end

              def with_code(code)
                chain[:code] = code

                self
              end

              def and_data(data)
                chain[:data] = data

                self
              end

              def and_message(message)
                chain[:message] = message

                self
              end

              def and_code(code)
                chain[:code] = code

                self
              end

              def calculate_value
                ##
                # TODO: Assert.
                #
                service_class.__send__(status, **kwargs)
              end

              private

              attr_reader :status, :service_class, :chain

              def kwargs
                @kwargs ||= calculate_kwargs
              end

              def calculate_kwargs
                kwargs = {}

                kwargs[:data] = data if used_data?
                kwargs[:message] = message if used_message?
                kwargs[:code] = code if used_code?

                kwargs[:service] = service_instance

                kwargs
              end

              def used_data?
                chain.key?(:data)
              end

              def used_message?
                chain.key?(:message)
              end

              def used_code?
                chain.key?(:code)
              end

              def data
                @data ||= chain[:data] || {}
              end

              def message
                @message ||= chain[:message] || ""
              end

              def code
                @code ||= chain[:code] || ""
              end

              def service_instance
                @service_instance ||= service_class.new_without_initialize
              end
            end
          end
        end
      end
    end
  end
end
