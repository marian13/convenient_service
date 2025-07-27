# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
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
                  @options = {}
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_data?
                  options.key?(:data)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_message?
                  options.key?(:message)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_code?
                  options.key?(:code)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_service?
                  options.key?(:service)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_original_service?
                  options.key?(:original_service)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_step?
                  options.key?(:step)
                end

                ##
                # @api private
                #
                # @return [Boolean]
                #
                def used_step_index?
                  options.key?(:step_index)
                end

                ##
                # @api private
                #
                # @return [Array<Symbol>]
                #
                def statuses
                  options[:statuses] || []
                end

                ##
                # @api private
                #
                # @return [Hash{Symbol => Object}]
                #
                def data
                  options[:data] || {}
                end

                ##
                # @api private
                #
                # @return [String]
                #
                def message
                  options[:message] || ""
                end

                ##
                # @api private
                #
                # @return [String, Symbol, nil]
                #
                def code
                  options[:code]
                end

                ##
                # @api private
                #
                # @return [Symbol, Symbol]
                #
                def comparison_method
                  options[:comparison_method] || Constants::DEFAULT_COMPARISON_METHOD
                end

                ##
                # @api private
                #
                # @return [ConvenientService::Service, nil]
                #
                def service
                  options[:service]
                end

                ##
                # @api private
                #
                # @return [ConvenientService::Service, nil]
                #
                def original_service
                  options[:original_service]
                end

                ##
                # @api private
                #
                # @return [ConvenientService::Service, Symbol, nil]
                #
                def step
                  options[:step]
                end

                ##
                # @api private
                #
                # @return [Integer, nil]
                #
                def step_index
                  options[:step_index]
                end

                ##
                # @api private
                #
                # @param other_statuses [Array<Symbol>]
                # @return [Array<Symbol>]
                #
                def statuses=(other_statuses)
                  options[:statuses] = other_statuses
                end

                ##
                # @api private
                #
                # @param other_comparison_method [Symbol, Symbol]
                # @return [Symbol, Symbol]
                #
                def comparison_method=(other_comparison_method)
                  options[:comparison_method] = other_comparison_method
                end

                ##
                # @api private
                #
                # @param other_data [Hash{Symbol => Object}]
                # @return [Hash{Symbol => Object}]
                #
                def data=(other_data)
                  options[:data] = other_data
                end

                ##
                # @api private
                #
                # @param other_message [String]
                # @return [String]
                #
                def message=(other_message)
                  options[:message] = other_message
                end

                ##
                # @api private
                #
                # @param other_code [Symbol]
                # @return [Symbol]
                #
                def code=(other_code)
                  options[:code] = other_code
                end

                ##
                # @api private
                #
                # @param other_service [ConvenientService::Service]
                # @return [ConvenientService::Service]
                #
                def service=(other_service)
                  options[:service] = other_service
                end

                ##
                # @api private
                #
                # @param other_service [ConvenientService::Service]
                # @return [ConvenientService::Service]
                #
                def original_service=(other_service)
                  options[:original_service] = other_service
                end

                ##
                # @api private
                #
                # @param other_step [ConvenientService::Service, Symbol]
                # @return [ConvenientService::Service, Symbol]
                #
                def step=(other_step)
                  options[:step] = other_step
                end

                ##
                # @api private
                #
                # @param other_step_index [Integer]
                # @return [Integer]
                #
                def step_index=(other_step_index)
                  options[:step_index] = other_step_index
                end

                ##
                # @api private
                #
                # @param other [Object] Can be any type.
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if options != other.options

                  true
                end

                protected

                ##
                # @!attribute options [r]
                #   @return [Hash{Symbol => Object}]
                #
                attr_reader :options
              end
            end
          end
        end
      end
    end
  end
end
