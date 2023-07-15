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
                  class Code
                    module Concern
                      module ClassMethods
                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code, nil]
                        #
                        def cast(other)
                          case other
                          when ::String
                            new(value: other.to_sym)
                          when ::Symbol
                            new(value: other)
                          when Code
                            new(value: other.value)
                          end
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        # @internal
                        #   NOTE: Check `Module.===` in order to get an idea of how `super` works.
                        #   - https://ruby-doc.org/core-2.7.0/Module.html#method-i-3D-3D-3D
                        #
                        def ===(other)
                          Commands::IsCode.call(code: other) || super
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
