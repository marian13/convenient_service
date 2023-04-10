# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Array < Caches::Base
            module Entities
              class Pair
                ##
                # @!attribute [r] key
                #   @return [ConvenientService::Support::Cache::Entities::Key]
                #
                attr_reader :key

                ##
                # @!attribute [rw] value
                #   @return [Object] Can be any type.
                #
                attr_accessor :value

                ##
                # @param key [Object] Can be any type.
                # @param value [Object] Can be any type.
                # @return [void]
                #
                def initialize(key:, value:)
                  @key = key
                  @value = value
                end
              end
            end
          end
        end
      end
    end
  end
end
