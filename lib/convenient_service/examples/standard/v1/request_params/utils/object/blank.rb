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
              class Blank < ConvenientService::Command
                attr_reader :object

                def initialize(object)
                  @object = object
                end

                ##
                # https://api.rubyonrails.org/classes/Object.html#method-i-blank-3F
                #
                def call
                  object.respond_to?(:empty?) ? !!object.empty? : !object
                end
              end
            end
          end
        end
      end
    end
  end
end
