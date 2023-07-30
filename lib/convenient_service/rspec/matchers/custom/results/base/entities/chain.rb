# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              class Chain
                ##
                # @api private
                #
                # @return [void]
                #
                def initialize
                  @hash = {}
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_data?
                  hash.key?(:data)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_message?
                  hash.key?(:message)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_code?
                  hash.key?(:code)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_of_service?
                  hash.key?(:service)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_of_step?
                  hash.key?(:step)
                end

                ##
                # @api private
                #
                # @return [Array<Symbol>]
                #
                def statuses
                  hash[:statuses]
                end

                ##
                # @api private
                #
                # @return [Hash{Symbol => Object}]
                #
                def data
                  hash[:data] || {}
                end

                ##
                # @api private
                #
                # @return [String]
                #
                def message
                  hash[:message] || ""
                end

                ##
                # @api private
                #
                # @return [String, Symbol]
                #
                def code
                  hash[:code] || ""
                end

                ##
                # @api private
                #
                # @return [Symbol, Symbol]
                #
                def comparison_method
                  hash[:comparison_method] || Constants::DEFAULT_COMPARISON_METHOD
                end

                ##
                # @api private
                #
                # @return [ConvenientService::Service]
                #
                def service
                  hash[:service]
                end

                ##
                # @api private
                #
                # @return [ConvenientService::Service, Symbol]
                #
                def step
                  hash[:step]
                end

                ##
                # @api private
                #
                # @param other_statuses [Array<Symbol>]
                # @return [Array<Symbol>]
                #
                def statuses=(other_statuses)
                  hash[:statuses] = other_statuses
                end

                ##
                # @api private
                #
                # @param other_comparison_method [Symbol, Symbol]
                # @return [Symbol, Symbol]
                #
                def comparison_method=(other_comparison_method)
                  hash[:comparison_method] = other_comparison_method
                end

                ##
                # @api private
                #
                # @param other_data [Hash{Symbol => Object}]
                # @return [Hash{Symbol => Object}]
                #
                def data=(other_data)
                  hash[:data] = other_data
                end

                ##
                # @api private
                #
                # @param other_message [String]
                # @return [String]
                #
                def message=(other_message)
                  hash[:message] = other_message
                end

                ##
                # @api private
                #
                # @param other_code [Symbol]
                # @return [Symbol]
                #
                def code=(other_code)
                  hash[:code] = other_code
                end

                ##
                # @api private
                #
                # @param other_service [ConvenientService::Service]
                # @return [ConvenientService::Service]
                #
                def service=(other_service)
                  hash[:service] = other_service
                end

                ##
                # @api private
                #
                # @param other_step [ConvenientService::Service, Symbol]
                # @return [ConvenientService::Service, Symbol]
                #
                def step=(other_step)
                  hash[:step] = other_step
                end

                ##
                # @api private
                #
                # @param other [Object] Can be any type.
                # @return [Boolean, nil]
                #
                def ==(other)
                  return nil unless other.instance_of?(self.class)

                  return false if hash != other.hash

                  true
                end

                protected

                ##
                # @!attribute hash [r]
                #   @return [Hash{Symbol => Object}]
                #
                attr_reader :hash
              end
            end
          end
        end
      end
    end
  end
end
