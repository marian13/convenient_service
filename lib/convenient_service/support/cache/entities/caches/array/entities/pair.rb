# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
                # @!attribute [r] value
                #   @return [Object] Can be any type.
                #
                attr_reader :value

                ##
                # @param key [Object] Can be any type.
                # @param value [Object] Can be any type.
                # @return [void]
                #
                def initialize(key:, value:)
                  @key = key
                  @value = value
                end

                ##
                # @param other [Object] Can be any type.
                # @return [void]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if key != other.key
                  return false if value != other.value

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end
