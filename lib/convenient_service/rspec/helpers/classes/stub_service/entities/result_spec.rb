# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class StubService < Support::Command
          module Entities
            ##
            # @internal
            #   IMPORTANT: Do NOT cache `data`, `message`, and `code` since they can be set multiple times by `with_data`, `and_data`, `with_message`, `and_message`, `with_code`, and `and_code`.
            #
            class ResultSpec
              ##
              # @param status [Symbol]
              # @param service_class [Class]
              # @param chain [Hash]
              # @return [void]
              #
              def initialize(status:, service_class: nil, chain: {})
                @status = status
                @service_class = service_class
                @chain = chain
              end

              ##
              # @param service_class [Class]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def for(service_class)
                self.class.new(status: status, service_class: service_class, chain: chain)
              end

              ##
              # @param data [Hash]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def with_data(data)
                chain[:data] = data

                self
              end

              ##
              # @param message [String]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def with_message(message)
                chain[:message] = message

                self
              end

              ##
              # @param code [String]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def with_code(code)
                chain[:code] = code

                self
              end

              ##
              # @param data [Hash]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def and_data(data)
                chain[:data] = data

                self
              end

              ##
              # @param message [String]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def and_message(message)
                chain[:message] = message

                self
              end

              ##
              # @param code [String]
              # @return [ConvenientService::RSpec::Helpers::Classes::StubService::Entities::ResultSpec]
              #
              def and_code(code)
                chain[:code] = code

                self
              end

              ##
              # @return [Object]
              #
              def calculate_value
                service_class.__send__(status, **kwargs).copy(overrides: {kwargs: {stubbed_result: true}})
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
                chain[:data] || {}
              end

              ##
              # @return [String]
              #
              def message
                chain[:message] || ""
              end

              ##
              # @return [String]
              #
              def code
                chain[:code] || ""
              end

              ##
              # @return [ConvenientService::Service]
              #
              def service_instance
                service_class.new_without_initialize
              end
            end
          end
        end
      end
    end
  end
end
