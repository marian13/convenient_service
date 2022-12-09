# frozen_string_literal: true

##
#
#
module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Utils
          module Integer
            class SafeParse < Support::Command
              attr_reader :string

              def initialize(string)
                @string = string
              end

              def call
                return unless string.instance_of?(::String)

                ::Kernel.Integer(string, exception: false)
              end
            end
          end
        end
      end
    end
  end
end
