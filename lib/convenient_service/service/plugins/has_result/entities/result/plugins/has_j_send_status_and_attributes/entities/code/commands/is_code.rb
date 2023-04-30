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
                  class Code
                    module Commands
                      ##
                      # Check whether `code` can be considered as `Code` instance.
                      #
                      class IsCode < Support::Command
                        ##
                        # @!attribute [r] code
                        #   @return [Object] Can any type.
                        #
                        attr_reader :code

                        ##
                        # @param code [Object] Can any type.
                        # @return [void]
                        #
                        def initialize(code:)
                          @code = code
                        end

                        ##
                        # @return [Boolean]
                        #
                        def call
                          code.class.include?(Entities::Code::Concern)
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
