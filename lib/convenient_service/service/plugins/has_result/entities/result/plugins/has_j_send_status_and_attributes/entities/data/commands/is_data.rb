# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Commands
                      class IsData < Support::Command
                        ##
                        # @!attribute [r] data
                        #   @return [Object] Can any type.
                        #
                        attr_reader :data

                        ##
                        # @param data [Object] Can any type.
                        # @return [void]
                        #
                        def initialize(data:)
                          @data = data
                        end

                        ##
                        # @return [void]
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
