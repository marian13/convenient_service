# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasAwesomePrintInspect
                module Commands
                  class GenerateInspectOutput < Support::Command
                    ##
                    # @!attribute [r] result
                    #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    attr_reader :result

                    ##
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @return [void]
                    #
                    def initialize(result:)
                      @result = result
                    end

                    ##
                    # @return [String]
                    #
                    def call
                      metadata = {}

                      metadata[:entity] = "Result"
                      metadata[:service] = service
                      metadata[:original_service] = original_service if include_original_service?
                      metadata[:status] = status
                      metadata[:data_keys] = data_keys if include_data_keys?
                      metadata[:message] = message if include_message?
                      metadata[:backtrace] = backtrace if include_backtrace?

                      {ConvenientService: metadata}.ai
                    end

                    private

                    ##
                    # @return [Class]
                    #
                    def service
                      Utils::Class.display_name(result.service.class)
                    end

                    ##
                    # @return [Class]
                    #
                    def original_service
                      Utils::Class.display_name(result.original_service.class)
                    end

                    ##
                    # @return [Symbol]
                    #
                    def status
                      result.status.to_sym
                    end

                    ##
                    # @return [Array<Symbol>]
                    #
                    def data_keys
                      result.unsafe_data.keys
                    end

                    ##
                    # @return [String, Array<String>]
                    #
                    def message
                      lines = result.unsafe_message.to_s.split("\n")

                      lines.one? ? lines.first : lines
                    end

                    ##
                    # @return [Array<String>]
                    #
                    # @internal
                    #   TODO: Specs.
                    #
                    def backtrace
                      locations = result.unhandled_exception.backtrace.to_a

                      (locations.size >= 10) ? locations.take(10) + ["..."] : locations
                    end

                    ##
                    # @return [Boolean]
                    #
                    def include_original_service?
                      result.service != result.original_service
                    end

                    ##
                    # @return [Boolean]
                    #
                    def include_data_keys?
                      result.unsafe_data.keys.any?
                    end

                    ##
                    # @return [Boolean]
                    #
                    # @internal
                    #   TODO: Specs.
                    #
                    def include_message?
                      !empty_message? || from_unhandled_exception?
                    end

                    ##
                    # @return [Boolean]
                    #
                    def include_backtrace?
                      from_unhandled_exception?
                    end

                    ##
                    # @return [Boolean]
                    #
                    def from_unhandled_exception?
                      Utils.memoize_including_falsy_values(self, :@from_unhandled_exception) { Utils.safe_send(result, :from_unhandled_exception?) }
                    end

                    ##
                    # @return [Boolean]
                    #
                    def empty_message?
                      result.unsafe_message.empty?
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
