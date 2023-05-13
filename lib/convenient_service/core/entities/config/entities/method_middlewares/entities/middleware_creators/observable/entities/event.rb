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

                      def add_observer(observer, func = default_handler_name)
                        super
                      end

                      ##
                      #
                      #
                      def notify_observers(...)
                        changed

                        super
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def default_handler_name
                        "handle_#{type}"
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
