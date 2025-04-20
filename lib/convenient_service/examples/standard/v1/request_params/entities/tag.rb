# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Entities
            class Tag
              def initialize(value:)
                @value = value
              end

              class << self
                def cast(value)
                  case value
                  when ::String
                    new(value: value.to_s)
                  end
                end
              end

              def ==(other)
                return unless other.instance_of?(self.class)

                value == other.value
              end

              def to_s
                value
              end

              protected

              attr_reader :value
            end
          end
        end
      end
    end
  end
end
