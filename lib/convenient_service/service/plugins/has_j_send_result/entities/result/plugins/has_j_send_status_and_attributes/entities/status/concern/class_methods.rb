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
                  class Status
                    module Concern
                      module ClassMethods
                        ##
                        # Checks whether an object is a status class.
                        #
                        # @api public
                        #
                        # @param status_class [Object] Can be any type.
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
                        #   status = result.status
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.data_class?(status.class)
                        #   # => true
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.data_class?(status)
                        #   # => false
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.data_class?(42)
                        #   # => false
                        #
                        def status_class?(status_class)
                          return false unless status_class.instance_of?(::Class)

                          status_class.include?(Entities::Status::Concern)
                        end

                        ##
                        # Checks whether an object is a status instance.
                        #
                        # @api public
                        #
                        # @param status [Object] Can be any type.
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
                        #   status = result.status
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.status?(status)
                        #   # => true
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.status?(status.class)
                        #   # => false
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status.status?(42)
                        #   # => false
                        #
                        def status?(status)
                          status_class?(status.class)
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status, nil]
                        #
                        def cast(other)
                          case other
                          when ::String
                            new(value: other.to_sym)
                          when ::Symbol
                            new(value: other)
                          when Status
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
                          status?(other) || super
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
