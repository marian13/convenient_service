# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Caller
                module Commands
                  class GenerateWithoutMiddlewaresName < Support::Command
                    ##
                    # @!attribute [r] name
                    #   @return [String, Symbol]
                    #
                    attr_reader :name

                    ##
                    # @param name [String, Symbol]
                    # @return [void]
                    #
                    def initialize(name:)
                      @name = name.to_s
                    end

                    ##
                    # @return [String]
                    #
                    def call
                      return "" if name.empty?

                      if name.end_with?("!")
                        "#{name.delete_suffix("!")}_without_middlewares!"
                      elsif name.end_with?("?")
                        "#{name.delete_suffix("?")}_without_middlewares?"
                      else
                        "#{name}_without_middlewares"
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
