# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Plugins
                      module HasInspect
                        module Commands
                          class GenerateInspectOutput < Support::Command
                            ##
                            # @!attribute [r] data
                            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                            #
                            attr_reader :data

                            ##
                            # @param data [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                            # @return [void]
                            #
                            def initialize(data:)
                              @data = data
                            end

                            ##
                            # @return [String]
                            #
                            def call
                              "<#{[printable_class, printable_values].reject(&:empty?).join(" ")}>"
                            end

                            private

                            ##
                            # @return [String]
                            #
                            def printable_class
                              "#{data.result.class.name}::Data"
                            end

                            ##
                            # @return [String]
                            #
                            def printable_values
                              data
                                .to_h
                                .map { |key, value| "#{key}: #{truncate(value.inspect)}" }
                                .join(" ")
                            end

                            ##
                            # @param value [String]
                            # @return [String]
                            #
                            def truncate(value)
                              Utils::String.truncate(value, 15, omission: "...")
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
    end
  end
end
