# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Commands
                  class CastJSendAttributes < Support::Command
                    attr_reader :attributes

                    def initialize(attributes:)
                      @attributes = attributes
                    end

                    def call
                      Structs::JSendAttributes.new(
                        service: attributes[:service],
                        status: Entities::Status.cast!(attributes[:status]),
                        data: Entities::Data.cast!(attributes[:data]),
                        message: Entities::Message.cast!(attributes[:message]),
                        code: Entities::Code.cast!(attributes[:code])
                      )
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
