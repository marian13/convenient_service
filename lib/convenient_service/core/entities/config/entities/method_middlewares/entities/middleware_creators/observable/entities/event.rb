# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module MiddlewareCreators
                ##
                # NOTE: `observer` is NOT a part of Ruby stdlib starting from Ruby 3.4. That is why a custom observer is implemented.
                #
                # @internal
                #   - https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html
                #   - https://github.com/ruby/observer
                #
                class Observable < MiddlewareCreators::Base
                  module Entities
                    class Event
                      ##
                      # @!attribute [r] type
                      #   @return [Symbol]
                      #
                      attr_reader :type

                      ##
                      # @param type [Symbol]
                      # @return [void]
                      #
                      def initialize(type:)
                        @type = type
                      end

                      ##
                      # @return [String]
                      #
                      def default_handler_name
                        "handle_#{type}"
                      end

                      ##
                      # @param observer [Object] Can be any type.
                      # @return [void]
                      #
                      # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html#method-i-add_observer
                      #
                      def add_observer(observer, func = default_handler_name)
                        observers[observer] = func
                      end

                      ##
                      # @return [void]
                      #
                      # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html#method-i-changed
                      # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html#method-i-notify_observers
                      #
                      def notify_observers(*args, **kwargs, &block)
                        observers.each { |observer, method| observer.__send__(method, *args, **kwargs, &block) }
                      end

                      ##
                      # @param other [Object] Can be any type.
                      # @return [Boolean, nil]
                      #
                      def ==(other)
                        return unless other.instance_of?(self.class)

                        return false if type != other.type
                        return false if observers != other.observers

                        true
                      end

                      protected

                      ##
                      # @return [Hash]
                      #
                      def observers
                        @observers ||= {}
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
