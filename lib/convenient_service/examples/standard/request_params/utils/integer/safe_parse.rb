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
            ##
            # TODO: Specs.
            #
            class SafeParse < Support::Command
              attr_reader :object

              def initialize(object)
                @object = object
              end

              def call
                ::Kernel.Integer(object, exception: false)
              end
            end
          end
        end
      end
    end
  end
end
