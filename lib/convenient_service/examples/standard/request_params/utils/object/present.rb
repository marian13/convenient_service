# frozen_string_literal: true

##
#
#
module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Utils
          module Object
            class Present < Support::Command
              attr_reader :object

              def initialize(object)
                @object = object
              end

              def call
                Utils::Object.blank?(object)
              end
            end
          end
        end
      end
    end
  end
end
