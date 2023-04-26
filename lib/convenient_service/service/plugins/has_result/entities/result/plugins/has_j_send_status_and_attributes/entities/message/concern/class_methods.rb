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
                  class Message
                    module Concern
                      module ClassMethods
                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message, nil]
                        #
                        def cast(other)
                          case other
                          when ::String
                            new(value: other)
                          when ::Symbol
                            new(value: other.to_s)
                          when Message
                            new(value: other.value)
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
