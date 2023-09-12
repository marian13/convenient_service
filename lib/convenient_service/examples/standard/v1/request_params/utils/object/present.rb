# frozen_string_literal: true

##
#
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module Object
              ##
              # TODO: Specs.
              #
              class Present < ConvenientService::Command
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
end
