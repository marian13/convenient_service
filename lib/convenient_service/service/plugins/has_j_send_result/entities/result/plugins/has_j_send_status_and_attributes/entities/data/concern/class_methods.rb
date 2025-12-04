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
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Concern
                      module ClassMethods
                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data, nil]
                        #
                        def cast(other)
                          case other
                          when ::Hash
                            new(value: other.transform_keys(&:to_sym))
                          when Data
                            new(value: other.__value__)
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
                          Commands::IsData.call(data: other) || super
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
