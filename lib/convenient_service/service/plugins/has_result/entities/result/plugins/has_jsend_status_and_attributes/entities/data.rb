# frozen_string_literal: true

require_relative "data/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Entities
                  class Data
                    include Support::Castable

                    extend ClassMethods

                    attr_reader :value

                    def initialize(value:)
                      @value = value
                    end

                    ##
                    # @param key [String, Symbol]
                    # @return [Boolean]
                    #
                    def has_attribute?(key)
                      value.has_key?(key.to_sym)
                    end

                    def ==(other)
                      casted = cast(other)

                      return unless casted

                      value == casted.value
                    end

                    def [](key)
                      value.fetch(key.to_sym) { raise Errors::NotExistingAttribute.new(attribute: key) }
                    end

                    def to_h
                      @to_h ||= value.to_h
                    end

                    def to_s
                      @to_s ||= to_h.to_s
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
