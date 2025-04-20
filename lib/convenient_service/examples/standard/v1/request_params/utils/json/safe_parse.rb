# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Tries to parse a JSON string and return the corresponding JSON object (Ruby hash, array, etc).
# Returns default value when fails to parse (default value is set to `nil` by default).
#
# IMPORTANT: `JSON::ParseError` is not the only exception that can be raised by `JSON.parse`.
# Check this link (`Ctrl + f' for `error'):
# https://github.com/ruby/ruby/blob/master/ext/json/lib/json.rb
#
module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module JSON
              class SafeParse < ConvenientService::Command
                attr_reader :json_string, :default_value

                def initialize(json_string, default_value: nil)
                  @json_string = json_string
                  @default_value = default_value
                end

                def call
                  return default_value unless json_string.instance_of?(::String)

                  begin
                    ::JSON.parse(json_string)
                  rescue
                    default_value
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
