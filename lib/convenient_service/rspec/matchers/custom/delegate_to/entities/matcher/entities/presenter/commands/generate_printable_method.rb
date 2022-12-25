# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Entities
                class Presenter
                  module Commands
                    class GeneratePrintableMethod < Support::Command
                      ##
                      # @!attribute [r] object
                      #   @return [Object] Can be any type.
                      #
                      attr_reader :object

                      ##
                      # @!attribute [r] method
                      #   @return [Symbol, String]
                      #
                      attr_reader :method

                      ##
                      # @param object [Object] Can by any type.
                      # @param method [Symbol, String]
                      # @return [void]
                      #
                      def initialize(object:, method:)
                        @object = object
                        @method = method
                      end

                      def call
                        case Utils::Object.resolve_type(object)
                        when "class", "module"
                          "#{object}.#{method}"
                        when "instance"
                          "#{object.class}##{method}"
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
