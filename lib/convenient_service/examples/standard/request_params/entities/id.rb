# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Entities
          ##
          # TODO: https://ruby-doc.org/3.1.3/stdlibs/yaml/YAML/DBM.html
          #
          class ID
            def initialize(value:)
              @value = value
            end

            class << self
              def cast(value)
                case value
                when ::String, ::Integer
                  new(value: value.to_s)
                end
              end
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              value == other.value
            end

            def to_i
              value.to_i
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
