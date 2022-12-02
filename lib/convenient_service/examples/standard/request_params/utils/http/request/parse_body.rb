# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Utils
          module HTTP
            module Request
              class ParseBody < Support::Command
                attr_reader :http_string

                def initialize(http_string:)
                  @http_string = http_string
                end

                ##
                # IMPORTANT: Make sure length is set in `http_string`.
                #
                # - https://stackoverflow.com/a/17599778/12201472
                # - https://github.com/ruby/webrick/blob/v1.7.0/lib/webrick/httprequest.rb
                #
                def call
                  webrick_request = ::WEBrick::HTTPRequest.new(::WEBrick::Config::HTTP)

                  webrick_request.parse(::StringIO.new(http_string))

                  webrick_request.body
                rescue ::WEBrick::HTTPStatus::BadRequest
                  nil
                end
              end
            end
          end
        end
      end
    end
  end
end
