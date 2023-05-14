# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module MiddlewareCreators
                class Observable < MiddlewareCreators::Base
                  module Entities
                    class Event
                      include ::Observable

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
                        super
                      end

                      ##
                      # @return [void]
                      #
                      # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html#method-i-changed
                      # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html#method-i-notify_observers
                      #
                      def notify_observers(...)
                        changed

                        super
                      end

                      ##
                      # @param other [Object] Can be any type.
                      # @return [Boolean, nil]
                      #
                      def ==(other)
                        return unless other.instance_of?(self.class)

                        return false if type != other.type
                        return false if observer_peers != other.observer_peers

                        true
                      end

                      protected

                      ##
                      # @return [Hash]
                      #
                      # @see https://ruby-doc.org/stdlib-2.7.0/libdoc/observer/rdoc/Observable.html#method-i-count_observers
                      #
                      # @internal
                      #   IMPORTANT: This method is using inherited private instance varaible. Ruby may change its name without any warning.
                      #
                      def observer_peers
                        @observer_peers if defined? @observer_peers
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
