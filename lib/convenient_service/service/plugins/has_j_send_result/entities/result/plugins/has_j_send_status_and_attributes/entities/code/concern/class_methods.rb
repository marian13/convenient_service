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
                  class Code
                    module Concern
                      module ClassMethods
                        ##
                        # Checks whether an object is a code class.
                        #
                        # @api public
                        #
                        # @param code_class [Object] Can be any type.
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
                        #   code = result.code
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.data_class?(code.class)
                        #   # => true
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.data_class?(code)
                        #   # => false
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.data_class?(42)
                        #   # => false
                        #
                        def code_class?(code_class)
                          return false unless code_class.instance_of?(::Class)

                          code_class.include?(Entities::Code::Concern)
                        end

                        ##
                        # Checks whether an object is a code instance.
                        #
                        # @api public
                        #
                        # @param code [Object] Can be any type.
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
                        #   code = result.code
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.code?(code)
                        #   # => true
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.code?(code.class)
                        #   # => false
                        #
                        #   ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code.code?(42)
                        #   # => false
                        #
                        def code?(code)
                          code_class?(code.class)
                        end

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
                          code?(other) || super
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
