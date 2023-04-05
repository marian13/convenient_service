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
                    module Concern
                      module ClassMethods
                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data, nil]
                        #
                        def cast(other)
                          case other
                          when ::Hash
                            new(value: other.transform_keys(&:to_sym))
                          when Data
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
