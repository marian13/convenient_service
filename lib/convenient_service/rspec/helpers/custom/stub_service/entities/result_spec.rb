# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        ##
        # @internal
        #   TODO: Specs.
        #
        class StubService < Support::Command
          module Entities
            class ResultSpec
              ##
              # @param status [Symbol]
              # @param service_class [Class]
              # @param chain [Hash]
              # @return [void]
              # @since 0.1.0
              #
              def initialize(status:, service_class: nil, chain: {})
                @status = status
                @service_class = service_class
                @chain = chain
              end

              ##
              # @param service_class [Class]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def for(service_class)
                self.class.new(status: status, service_class: service_class, chain: chain)
              end

              ##
              # @param data [Hash]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def with_data(data)
                chain[:data] = data

                self
              end

              ##
              # @param message [String]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def with_message(message)
                chain[:message] = message

                self
              end

              ##
              # @param code [String]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def with_code(code)
                chain[:code] = code

                self
              end

              ##
              # @param data [Hash]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def and_data(data)
                chain[:data] = data

                self
              end

              ##
              # @param message [String]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def and_message(message)
                chain[:message] = message

                self
              end

              ##
              # @param code [String]
              # @return [ConvenientService::RSpec::Helpers::Custom::StubService::Entities::ResultSpec]
              # @since 0.1.0
              #
              def and_code(code)
                chain[:code] = code

                self
              end

              ##
              # @return [Object]
              #
              # @internal
              #    TODO: Assert.
              #
              def calculate_value
                service_class.__send__(status, **kwargs)
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if status != other.status
                return false if service_class != other.service_class
                return false if chain != other.chain

                true
              end

              protected

              ##
              # @!attribute [r] status
              #   @return [Symbol]
              #
              attr_reader :status

              ##
              # @!attribute [r] service_class
              #   @return [Class]
              #
              attr_reader :service_class

              ##
              # @!attribute [r] chain
              #   @return [Hash]
              #
              attr_reader :chain

              private

              ##
              # @return [Hash]
              #
              def kwargs
                @kwargs ||= calculate_kwargs
              end

              ##
              # @return [Hash]
              #
              def calculate_kwargs
                kwargs = {}

                kwargs[:data] = data if used_data?
                kwargs[:message] = message if used_message?
                kwargs[:code] = code if used_code?

                kwargs[:service] = service_instance

                kwargs
              end

              ##
              # @return [Boolean]
              #
              def used_data?
                chain.key?(:data)
              end

              ##
              # @return [Boolean]
              #
              def used_message?
                chain.key?(:message)
              end

              ##
              # @return [Boolean]
              #
              def used_code?
                chain.key?(:code)
              end

              ##
              # @return [Hash]
              #
              def data
                @data ||= chain[:data] || {}
              end

              ##
              # @return [String]
              #
              def message
                @message ||= chain[:message] || ""
              end

              ##
              # @return [String]
              #
              def code
                @code ||= chain[:code] || ""
              end

              ##
              # @return [Object]
              #
              def service_instance
                @service_instance ||= service_class.create_without_initialize
              end
            end
          end
        end
      end
    end
  end
end
