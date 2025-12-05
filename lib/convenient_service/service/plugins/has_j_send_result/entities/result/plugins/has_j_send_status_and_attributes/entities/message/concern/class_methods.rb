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
                  class Message
                    module Concern
                      module ClassMethods
                        ##
                        # Checks whether an object is a message class.
                        #
                        # @api public
                        #
                        # @param message_class [Object] Can be any type.
                        # @return [Boolean]
                        #
                        # @example Simple usage.
                        #   class Service
                        #     include ConvenientService::Standard::Config
                        #
                        #     def result
                        #       success
                        #     end
                        #   end
                        #
                        #   result = Service.result
                        #
                        #   result.success?
                        #
                        #   message = result.message
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.data_class?(message.class)
                        #   # => true
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.data_class?(message)
                        #   # => false
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.data_class?(42)
                        #   # => false
                        #
                        def message_class?(message_class)
                          return false unless message_class.instance_of?(::Class)

                          message_class.include?(Entities::Message::Concern)
                        end

                        ##
                        # Checks whether an object is a message instance.
                        #
                        # @api public
                        #
                        # @param message [Object] Can be any type.
                        # @return [Boolean]
                        #
                        # @example Simple usage.
                        #   class Service
                        #     include ConvenientService::Standard::Config
                        #
                        #     def result
                        #       success
                        #     end
                        #   end
                        #
                        #   result = Service.result
                        #
                        #   result.success?
                        #
                        #   message = result.message
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.message?(message)
                        #   # => true
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.message?(message.class)
                        #   # => false
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message.message?(42)
                        #   # => false
                        #
                        def message?(message)
                          message_class?(message.class)
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message, nil]
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

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        # @internal
                        #   NOTE: Check `Module.===` in order to get an idea of how `super` works.
                        #   - https://ruby-doc.org/core-2.7.0/Module.html#method-i-3D-3D-3D
                        #
                        def ===(other)
                          message?(other) || super
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
