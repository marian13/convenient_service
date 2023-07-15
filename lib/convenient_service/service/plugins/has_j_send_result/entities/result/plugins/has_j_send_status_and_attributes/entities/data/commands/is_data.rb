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
                    module Commands
                      ##
                      # Check whether `data` can be considered as `Data` instance.
                      #
                      class IsData < Support::Command
                        ##
                        # @!attribute [r] data
                        #   @return [Object] Can be any type.
                        #
                        attr_reader :data

                        ##
                        # @param data [Object] Can be any type.
                        # @return [void]
                        #
                        def initialize(data:)
                          @data = data
                        end

                        ##
                        # @return [Boolean]
                        #
                        def call
                          data.class.include?(Entities::Data::Concern)
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
